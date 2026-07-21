-- Backs the admin "Control Authority" screen: a permission matrix per role.
create table role_permissions (
  id uuid primary key default uuid_generate_v4(),
  role app_role not null,
  permission text not null, -- e.g. 'products.manage', 'orders.manage', 'customers.view'
  allowed boolean not null default true,
  unique (role, permission)
);

alter table role_permissions enable row level security;

create policy "role_permissions_read" on role_permissions for select using (auth.role() = 'authenticated' or is_admin());
create policy "role_permissions_admin_write" on role_permissions for all using (is_admin()) with check (is_admin());

-- Seed a sensible default matrix.
insert into role_permissions (role, permission, allowed) values
  ('admin', 'dashboard.view', true),
  ('admin', 'orders.manage', true),
  ('admin', 'customers.manage', true),
  ('admin', 'coupons.manage', true),
  ('admin', 'categories.manage', true),
  ('admin', 'brands.manage', true),
  ('admin', 'products.manage', true),
  ('admin', 'reviews.moderate', true),
  ('admin', 'transactions.view', true),
  ('admin', 'roles.manage', true),
  ('store_manager', 'dashboard.view', true),
  ('store_manager', 'orders.manage', true),
  ('store_manager', 'products.manage', true),
  ('store_manager', 'categories.manage', true),
  ('store_manager', 'brands.manage', true),
  ('store_manager', 'coupons.manage', false),
  ('store_manager', 'customers.manage', false),
  ('store_manager', 'reviews.moderate', true),
  ('store_manager', 'transactions.view', false),
  ('store_manager', 'roles.manage', false),
  ('delivery_boy', 'dashboard.view', false),
  ('delivery_boy', 'orders.manage', true),
  ('delivery_boy', 'products.manage', false),
  ('delivery_boy', 'categories.manage', false),
  ('delivery_boy', 'brands.manage', false),
  ('delivery_boy', 'coupons.manage', false),
  ('delivery_boy', 'customers.manage', false),
  ('delivery_boy', 'reviews.moderate', false),
  ('delivery_boy', 'transactions.view', false),
  ('delivery_boy', 'roles.manage', false);
