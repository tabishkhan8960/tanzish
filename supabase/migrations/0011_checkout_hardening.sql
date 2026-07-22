-- Phase 1 checkout hardening.
--
-- Two real problems this fixes:
-- 1. Checkout trusted client-computed totals and unconditionally marked every
--    payment "paid" at order placement, including Cash on Delivery. Nothing
--    stopped a client from submitting an arbitrary total.
-- 2. Delivery cost was a hardcoded constant in the Flutter app, not a real
--    selectable option, and stock was never checked or decremented, so
--    overselling was possible.
--
-- This adds a real shipping_methods table and a SECURITY DEFINER place_order
-- function that recomputes everything server-side (price, coupon, shipping),
-- validates + reserves stock, and creates the order/items/payment atomically
-- — if any check fails, the whole function raises and nothing is written.

-- ============================================================================
-- SHIPPING METHODS
-- ============================================================================

create table shipping_methods (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  description text,
  price numeric(12,2) not null default 0,
  min_days int not null default 1,
  max_days int not null default 3,
  is_active boolean not null default true,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

alter table shipping_methods enable row level security;

create policy "shipping_methods_public_read" on shipping_methods for select using (is_active or is_admin());
create policy "shipping_methods_admin_insert" on shipping_methods for insert with check (is_admin());
create policy "shipping_methods_admin_update" on shipping_methods for update using (is_admin()) with check (is_admin());
create policy "shipping_methods_admin_delete" on shipping_methods for delete using (is_admin());

insert into shipping_methods (name, description, price, min_days, max_days, sort_order) values
  ('Standard Delivery', 'Delivered in 4-6 business days', 30, 4, 6, 1),
  ('Express Delivery', 'Delivered in 1-2 business days', 99, 1, 2, 2);

alter table orders add column shipping_method_id uuid references shipping_methods(id) on delete set null;

-- A UPI ID for the manual-verification payment flow (shown to the shopper,
-- they pay via their own UPI app and submit the UTR). Replace the
-- placeholder with your real collection UPI ID before going live:
--   update settings set value = '"your-real-id@bank"'::jsonb where key = 'upi_id';
insert into settings (key, value) values ('upi_id', '"store@upi"'::jsonb)
  on conflict (key) do nothing;

-- ============================================================================
-- place_order: atomic, server-side-verified order creation
-- ============================================================================

create or replace function place_order(
  p_shipping_address_id uuid,
  p_shipping_method_id uuid,
  p_coupon_code text default null,
  p_payment_provider text default 'cod',
  p_payment_transaction_ref text default null
) returns orders
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_order orders;
  v_order_id uuid;
  v_subtotal numeric(12,2) := 0;
  v_shipping_fee numeric(12,2) := 0;
  v_discount numeric(12,2) := 0;
  v_total numeric(12,2) := 0;
  v_coupon coupons;
  v_cart_count int;
  v_item record;
  v_inventory_id uuid;
  v_inventory_qty int;
begin
  if v_user_id is null then
    raise exception 'Not authenticated';
  end if;

  if p_payment_provider not in ('cod', 'upi') then
    raise exception 'Unsupported payment provider';
  end if;

  select count(*) into v_cart_count from cart where user_id = v_user_id;
  if v_cart_count = 0 then
    raise exception 'Your cart is empty';
  end if;

  if p_shipping_address_id is null or not exists (
    select 1 from addresses where id = p_shipping_address_id and user_id = v_user_id
  ) then
    raise exception 'Select a valid delivery address';
  end if;

  -- Recompute subtotal from live product prices — never trust a client total.
  select coalesce(sum(p.price * c.quantity), 0) into v_subtotal
  from cart c join products p on p.id = c.product_id
  where c.user_id = v_user_id;

  if p_shipping_method_id is not null then
    select price into v_shipping_fee from shipping_methods where id = p_shipping_method_id and is_active;
    if not found then
      raise exception 'Select a valid delivery method';
    end if;
  end if;

  if p_coupon_code is not null and length(trim(p_coupon_code)) > 0 then
    select * into v_coupon from coupons where code = upper(trim(p_coupon_code)) and is_active;
    if not found then
      raise exception 'Invalid or expired coupon';
    end if;
    if v_coupon.expires_at is not null and v_coupon.expires_at < now() then
      raise exception 'Coupon has expired';
    end if;
    if v_coupon.starts_at is not null and v_coupon.starts_at > now() then
      raise exception 'Coupon is not active yet';
    end if;
    if v_coupon.usage_limit is not null and v_coupon.used_count >= v_coupon.usage_limit then
      raise exception 'Coupon usage limit reached';
    end if;
    if v_subtotal < v_coupon.min_order_amount then
      raise exception 'Order does not meet the minimum amount for this coupon';
    end if;

    if v_coupon.discount_type = 'percentage' then
      v_discount := round(v_subtotal * (v_coupon.discount_value / 100.0), 2);
      if v_coupon.max_discount_amount is not null and v_discount > v_coupon.max_discount_amount then
        v_discount := v_coupon.max_discount_amount;
      end if;
    else
      v_discount := v_coupon.discount_value;
    end if;
    if v_discount > v_subtotal then
      v_discount := v_subtotal;
    end if;
  end if;

  v_total := v_subtotal + v_shipping_fee - v_discount;

  -- Stock check + reservation. Only products with an inventory row matching
  -- the cart line's exact variant are tracked; base products with no
  -- variants recorded are treated as always available.
  for v_item in
    select c.product_id, c.variant_attributes, c.quantity, p.name as product_name
    from cart c join products p on p.id = c.product_id
    where c.user_id = v_user_id
  loop
    select id, quantity into v_inventory_id, v_inventory_qty
    from inventory
    where product_id = v_item.product_id and variant_attributes = v_item.variant_attributes
    limit 1;

    if v_inventory_id is not null then
      if v_inventory_qty < v_item.quantity then
        raise exception '% is out of stock', v_item.product_name;
      end if;
      update inventory set quantity = quantity - v_item.quantity where id = v_inventory_id;
    end if;
  end loop;

  insert into orders (
    user_id, shipping_address_id, billing_address_id, shipping_method_id,
    coupon_id, subtotal, shipping_fee, discount, total, status
  ) values (
    v_user_id, p_shipping_address_id, p_shipping_address_id, p_shipping_method_id,
    v_coupon.id, v_subtotal, v_shipping_fee, v_discount, v_total, 'pending'
  ) returning id into v_order_id;

  insert into order_items (order_id, product_id, product_name, variant_attributes, unit_price, quantity, subtotal)
  select v_order_id, c.product_id, p.name, c.variant_attributes, p.price, c.quantity, p.price * c.quantity
  from cart c join products p on p.id = c.product_id
  where c.user_id = v_user_id;

  if v_coupon.id is not null then
    update coupons set used_count = used_count + 1 where id = v_coupon.id;
  end if;

  -- Every payment starts pending: COD is collected on delivery, UPI needs
  -- admin to verify the UTR against their bank/UPI app before it's marked
  -- paid. Nothing here ever auto-marks an order as paid.
  insert into payments (order_id, provider, status, amount, transaction_ref)
  values (v_order_id, p_payment_provider, 'pending', v_total, p_payment_transaction_ref);

  delete from cart where user_id = v_user_id;

  select * into v_order from orders where id = v_order_id;
  return v_order;
end;
$$;

grant execute on function place_order(uuid, uuid, text, text, text) to authenticated;
