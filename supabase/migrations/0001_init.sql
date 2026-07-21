-- ShopHub E-Commerce Platform — initial schema
-- Project: qbcdavvwlsisxcvaujfp
-- Tables per PRD: profiles, roles, categories, brands, products, product_images,
-- inventory, addresses, cart, wishlist, orders, order_items, payments, coupons,
-- reviews, notifications, settings.

-- ============================================================================
-- EXTENSIONS
-- ============================================================================
create extension if not exists "uuid-ossp";

-- ============================================================================
-- ENUMS
-- ============================================================================
create type app_role as enum ('admin', 'customer', 'store_manager', 'delivery_boy');
create type order_status as enum ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded');
create type payment_status as enum ('pending', 'paid', 'failed', 'refunded');
create type discount_type as enum ('percentage', 'fixed');
create type address_type as enum ('shipping', 'billing');

-- ============================================================================
-- HELPER: updated_at trigger
-- ============================================================================
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ============================================================================
-- ROLES (lookup table; profiles.role denormalizes the enum for fast RLS checks)
-- ============================================================================
create table roles (
  name app_role primary key,
  description text
);

insert into roles (name, description) values
  ('admin', 'Full access to admin panel and all data'),
  ('customer', 'Shops on the customer app'),
  ('store_manager', 'Manages catalog and orders for a store (future)'),
  ('delivery_boy', 'Fulfils delivery of orders (future)');

-- ============================================================================
-- PROFILES (1:1 with auth.users)
-- ============================================================================
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role app_role not null default 'customer' references roles(name),
  full_name text,
  phone text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_profiles_updated_at
  before update on profiles
  for each row execute function set_updated_at();

-- Auto-create a profile row when a new auth user signs up.
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data ->> 'full_name');
  return new;
end;
$$ language plpgsql security definer set search_path = public;

create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();

-- security-definer helper so RLS policies can check role without recursive
-- self-referencing lookups against profiles under RLS.
create or replace function is_admin()
returns boolean as $$
  select exists (
    select 1 from profiles where id = auth.uid() and role = 'admin'
  );
$$ language sql stable security definer set search_path = public;

-- ============================================================================
-- CATEGORIES
-- ============================================================================
create table categories (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  slug text not null unique,
  description text,
  image_url text,
  parent_id uuid references categories(id) on delete set null,
  sort_order int not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_categories_updated_at
  before update on categories
  for each row execute function set_updated_at();

-- ============================================================================
-- BRANDS
-- ============================================================================
create table brands (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  slug text not null unique,
  logo_url text,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_brands_updated_at
  before update on brands
  for each row execute function set_updated_at();

-- ============================================================================
-- PRODUCTS
-- ============================================================================
create table products (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  slug text not null unique,
  description text,
  brand_id uuid references brands(id) on delete set null,
  category_id uuid references categories(id) on delete set null,
  sku text unique,
  price numeric(12,2) not null check (price >= 0),
  compare_at_price numeric(12,2) check (compare_at_price >= 0),
  attributes jsonb not null default '{}'::jsonb, -- e.g. {"sizes":["6UK","7UK"],"colors":["Black","Red"]}
  rating_avg numeric(3,2) not null default 0,
  rating_count int not null default 0,
  is_active boolean not null default true,
  is_featured boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_products_category on products(category_id);
create index idx_products_brand on products(brand_id);
create index idx_products_active on products(is_active);

create trigger trg_products_updated_at
  before update on products
  for each row execute function set_updated_at();

-- ============================================================================
-- PRODUCT IMAGES
-- ============================================================================
create table product_images (
  id uuid primary key default uuid_generate_v4(),
  product_id uuid not null references products(id) on delete cascade,
  image_url text not null,
  sort_order int not null default 0,
  is_primary boolean not null default false
);

create index idx_product_images_product on product_images(product_id);

-- ============================================================================
-- INVENTORY (per product, optionally per variant via attributes jsonb)
-- ============================================================================
create table inventory (
  id uuid primary key default uuid_generate_v4(),
  product_id uuid not null references products(id) on delete cascade,
  variant_attributes jsonb not null default '{}'::jsonb, -- e.g. {"size":"7UK","color":"Black"}
  quantity int not null default 0 check (quantity >= 0),
  low_stock_threshold int not null default 5,
  updated_at timestamptz not null default now(),
  unique (product_id, variant_attributes)
);

create trigger trg_inventory_updated_at
  before update on inventory
  for each row execute function set_updated_at();

-- ============================================================================
-- ADDRESSES
-- ============================================================================
create table addresses (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  type address_type not null default 'shipping',
  full_name text not null,
  phone text,
  address_line1 text not null,
  address_line2 text,
  city text not null,
  state text,
  postal_code text,
  country text not null,
  is_default boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_addresses_user on addresses(user_id);

create trigger trg_addresses_updated_at
  before update on addresses
  for each row execute function set_updated_at();

-- ============================================================================
-- CART
-- ============================================================================
create table cart (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  product_id uuid not null references products(id) on delete cascade,
  variant_attributes jsonb not null default '{}'::jsonb,
  quantity int not null default 1 check (quantity > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, product_id, variant_attributes)
);

create trigger trg_cart_updated_at
  before update on cart
  for each row execute function set_updated_at();

-- ============================================================================
-- WISHLIST
-- ============================================================================
create table wishlist (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  product_id uuid not null references products(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, product_id)
);

-- ============================================================================
-- COUPONS
-- ============================================================================
create table coupons (
  id uuid primary key default uuid_generate_v4(),
  code text not null unique,
  description text,
  discount_type discount_type not null,
  discount_value numeric(12,2) not null check (discount_value >= 0),
  min_order_amount numeric(12,2) not null default 0,
  max_discount_amount numeric(12,2),
  usage_limit int,
  used_count int not null default 0,
  starts_at timestamptz,
  expires_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_coupons_updated_at
  before update on coupons
  for each row execute function set_updated_at();

-- ============================================================================
-- ORDERS
-- ============================================================================
create table orders (
  id uuid primary key default uuid_generate_v4(),
  order_number text not null unique default ('SH-' || upper(substr(replace(uuid_generate_v4()::text, '-', ''), 1, 10))),
  user_id uuid not null references profiles(id) on delete restrict,
  status order_status not null default 'pending',
  shipping_address_id uuid references addresses(id) on delete set null,
  billing_address_id uuid references addresses(id) on delete set null,
  coupon_id uuid references coupons(id) on delete set null,
  subtotal numeric(12,2) not null default 0,
  shipping_fee numeric(12,2) not null default 0,
  discount numeric(12,2) not null default 0,
  total numeric(12,2) not null default 0,
  currency text not null default 'USD',
  placed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_orders_user on orders(user_id);
create index idx_orders_status on orders(status);

create trigger trg_orders_updated_at
  before update on orders
  for each row execute function set_updated_at();

-- ============================================================================
-- ORDER ITEMS
-- ============================================================================
create table order_items (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references orders(id) on delete cascade,
  product_id uuid references products(id) on delete set null,
  product_name text not null, -- snapshot at time of purchase
  variant_attributes jsonb not null default '{}'::jsonb,
  unit_price numeric(12,2) not null,
  quantity int not null check (quantity > 0),
  subtotal numeric(12,2) not null
);

create index idx_order_items_order on order_items(order_id);

-- ============================================================================
-- PAYMENTS
-- ============================================================================
create table payments (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references orders(id) on delete cascade,
  provider text not null, -- 'visa' | 'paypal' | 'mastercard' | 'stripe' | ...
  status payment_status not null default 'pending',
  amount numeric(12,2) not null,
  currency text not null default 'USD',
  transaction_ref text,
  paid_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_payments_order on payments(order_id);

create trigger trg_payments_updated_at
  before update on payments
  for each row execute function set_updated_at();

-- ============================================================================
-- REVIEWS
-- ============================================================================
create table reviews (
  id uuid primary key default uuid_generate_v4(),
  product_id uuid not null references products(id) on delete cascade,
  user_id uuid not null references profiles(id) on delete cascade,
  order_item_id uuid references order_items(id) on delete set null,
  rating int not null check (rating between 1 and 5),
  comment text,
  images text[] not null default '{}',
  is_approved boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (product_id, user_id, order_item_id)
);

create index idx_reviews_product on reviews(product_id);

create trigger trg_reviews_updated_at
  before update on reviews
  for each row execute function set_updated_at();

-- Keep products.rating_avg / rating_count in sync with approved reviews.
create or replace function refresh_product_rating()
returns trigger as $$
declare
  target_product uuid := coalesce(new.product_id, old.product_id);
begin
  update products p
  set rating_avg = coalesce((select avg(rating) from reviews where product_id = target_product and is_approved), 0),
      rating_count = (select count(*) from reviews where product_id = target_product and is_approved)
  where p.id = target_product;
  return null;
end;
$$ language plpgsql security definer set search_path = public;

create trigger trg_reviews_refresh_rating
  after insert or update or delete on reviews
  for each row execute function refresh_product_rating();

-- ============================================================================
-- NOTIFICATIONS
-- ============================================================================
create table notifications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  title text not null,
  body text,
  type text not null default 'general', -- order_update | promo | general ...
  data jsonb not null default '{}'::jsonb,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create index idx_notifications_user on notifications(user_id, is_read);

-- ============================================================================
-- SETTINGS (key/value app configuration)
-- ============================================================================
create table settings (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

create trigger trg_settings_updated_at
  before update on settings
  for each row execute function set_updated_at();

insert into settings (key, value) values
  ('shipping_fee', '30'),
  ('currency', '"USD"'),
  ('tax_rate', '0');

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
alter table roles enable row level security;
alter table profiles enable row level security;
alter table categories enable row level security;
alter table brands enable row level security;
alter table products enable row level security;
alter table product_images enable row level security;
alter table inventory enable row level security;
alter table addresses enable row level security;
alter table cart enable row level security;
alter table wishlist enable row level security;
alter table coupons enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;
alter table payments enable row level security;
alter table reviews enable row level security;
alter table notifications enable row level security;
alter table settings enable row level security;

-- roles: readable by anyone authenticated, writable by admin only
create policy "roles_select_all" on roles for select using (true);
create policy "roles_admin_write" on roles for all using (is_admin()) with check (is_admin());

-- profiles: users manage their own row; admins manage all
create policy "profiles_select_own_or_admin" on profiles for select using (id = auth.uid() or is_admin());
create policy "profiles_update_own_or_admin" on profiles for update using (id = auth.uid() or is_admin());
create policy "profiles_admin_insert" on profiles for insert with check (is_admin() or id = auth.uid());
create policy "profiles_admin_delete" on profiles for delete using (is_admin());

-- categories / brands / products / product_images: public read (active only for
-- anonymous/customers), admin full write
create policy "categories_public_read" on categories for select using (is_active or is_admin());
create policy "categories_admin_write" on categories for insert with check (is_admin());
create policy "categories_admin_update" on categories for update using (is_admin());
create policy "categories_admin_delete" on categories for delete using (is_admin());

create policy "brands_public_read" on brands for select using (is_active or is_admin());
create policy "brands_admin_write" on brands for insert with check (is_admin());
create policy "brands_admin_update" on brands for update using (is_admin());
create policy "brands_admin_delete" on brands for delete using (is_admin());

create policy "products_public_read" on products for select using (is_active or is_admin());
create policy "products_admin_write" on products for insert with check (is_admin());
create policy "products_admin_update" on products for update using (is_admin());
create policy "products_admin_delete" on products for delete using (is_admin());

create policy "product_images_public_read" on product_images for select using (true);
create policy "product_images_admin_write" on product_images for insert with check (is_admin());
create policy "product_images_admin_update" on product_images for update using (is_admin());
create policy "product_images_admin_delete" on product_images for delete using (is_admin());

-- inventory: admin only
create policy "inventory_admin_all" on inventory for all using (is_admin()) with check (is_admin());

-- addresses: owner or admin
create policy "addresses_owner_select" on addresses for select using (user_id = auth.uid() or is_admin());
create policy "addresses_owner_insert" on addresses for insert with check (user_id = auth.uid() or is_admin());
create policy "addresses_owner_update" on addresses for update using (user_id = auth.uid() or is_admin());
create policy "addresses_owner_delete" on addresses for delete using (user_id = auth.uid() or is_admin());

-- cart: owner only (admin can view for support/debug)
create policy "cart_owner_select" on cart for select using (user_id = auth.uid() or is_admin());
create policy "cart_owner_insert" on cart for insert with check (user_id = auth.uid());
create policy "cart_owner_update" on cart for update using (user_id = auth.uid());
create policy "cart_owner_delete" on cart for delete using (user_id = auth.uid());

-- wishlist: owner only
create policy "wishlist_owner_select" on wishlist for select using (user_id = auth.uid() or is_admin());
create policy "wishlist_owner_insert" on wishlist for insert with check (user_id = auth.uid());
create policy "wishlist_owner_delete" on wishlist for delete using (user_id = auth.uid());

-- coupons: active coupons readable by authenticated users (to validate at
-- checkout); full management by admin
create policy "coupons_read_active" on coupons for select using (is_active or is_admin());
create policy "coupons_admin_write" on coupons for insert with check (is_admin());
create policy "coupons_admin_update" on coupons for update using (is_admin());
create policy "coupons_admin_delete" on coupons for delete using (is_admin());

-- orders: owner or admin
create policy "orders_owner_select" on orders for select using (user_id = auth.uid() or is_admin());
create policy "orders_owner_insert" on orders for insert with check (user_id = auth.uid() or is_admin());
create policy "orders_owner_update" on orders for update using (is_admin() or user_id = auth.uid());
create policy "orders_admin_delete" on orders for delete using (is_admin());

-- order_items: visible if you own the parent order, or admin
create policy "order_items_select" on order_items for select using (
  is_admin() or exists (select 1 from orders o where o.id = order_id and o.user_id = auth.uid())
);
create policy "order_items_insert" on order_items for insert with check (
  is_admin() or exists (select 1 from orders o where o.id = order_id and o.user_id = auth.uid())
);
create policy "order_items_admin_update" on order_items for update using (is_admin());
create policy "order_items_admin_delete" on order_items for delete using (is_admin());

-- payments: visible if you own the parent order, or admin
create policy "payments_select" on payments for select using (
  is_admin() or exists (select 1 from orders o where o.id = order_id and o.user_id = auth.uid())
);
create policy "payments_insert" on payments for insert with check (
  is_admin() or exists (select 1 from orders o where o.id = order_id and o.user_id = auth.uid())
);
create policy "payments_admin_update" on payments for update using (is_admin());

-- reviews: approved reviews are public; owner manages their own; admin moderates
create policy "reviews_public_read" on reviews for select using (is_approved or user_id = auth.uid() or is_admin());
create policy "reviews_owner_insert" on reviews for insert with check (user_id = auth.uid());
create policy "reviews_owner_update" on reviews for update using (user_id = auth.uid() or is_admin());
create policy "reviews_owner_delete" on reviews for delete using (user_id = auth.uid() or is_admin());

-- notifications: owner only
create policy "notifications_owner_select" on notifications for select using (user_id = auth.uid() or is_admin());
create policy "notifications_owner_update" on notifications for update using (user_id = auth.uid());
create policy "notifications_admin_insert" on notifications for insert with check (is_admin() or user_id = auth.uid());
create policy "notifications_owner_delete" on notifications for delete using (user_id = auth.uid() or is_admin());

-- settings: readable by any authenticated user, writable by admin only
create policy "settings_read_authenticated" on settings for select using (auth.role() = 'authenticated' or is_admin());
create policy "settings_admin_write" on settings for insert with check (is_admin());
create policy "settings_admin_update" on settings for update using (is_admin());
create policy "settings_admin_delete" on settings for delete using (is_admin());
