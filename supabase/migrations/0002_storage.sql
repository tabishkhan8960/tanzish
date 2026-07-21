-- Storage buckets per PRD: product-images, category-images, brand-logos,
-- banners, avatars, review-images, invoices.

insert into storage.buckets (id, name, public)
values
  ('product-images', 'product-images', true),
  ('category-images', 'category-images', true),
  ('brand-logos', 'brand-logos', true),
  ('banners', 'banners', true),
  ('avatars', 'avatars', true),
  ('review-images', 'review-images', true),
  ('invoices', 'invoices', false)
on conflict (id) do nothing;

-- Public, read-only buckets: anyone can view, only admins can manage.
create policy "public_buckets_read"
  on storage.objects for select
  using (bucket_id in ('product-images','category-images','brand-logos','banners','review-images'));

create policy "public_buckets_admin_write"
  on storage.objects for insert
  with check (bucket_id in ('product-images','category-images','brand-logos','banners') and is_admin());

create policy "public_buckets_admin_update"
  on storage.objects for update
  using (bucket_id in ('product-images','category-images','brand-logos','banners') and is_admin());

create policy "public_buckets_admin_delete"
  on storage.objects for delete
  using (bucket_id in ('product-images','category-images','brand-logos','banners') and is_admin());

-- Avatars: publicly viewable, but each user manages only their own file
-- (object path convention: {user_id}/avatar.ext)
create policy "avatars_owner_write"
  on storage.objects for insert
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "avatars_owner_update"
  on storage.objects for update
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "avatars_owner_delete"
  on storage.objects for delete
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text or is_admin());

-- Review images: owner uploads under their own folder, admin can moderate/delete
create policy "review_images_owner_write"
  on storage.objects for insert
  with check (bucket_id = 'review-images' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "review_images_owner_delete"
  on storage.objects for delete
  using (bucket_id = 'review-images' and ((storage.foldername(name))[1] = auth.uid()::text or is_admin()));

-- Invoices: private bucket. Owner (order's user) and admin can read; only
-- admin/service role generates them.
create policy "invoices_owner_read"
  on storage.objects for select
  using (
    bucket_id = 'invoices'
    and (is_admin() or (storage.foldername(name))[1] = auth.uid()::text)
  );

create policy "invoices_admin_write"
  on storage.objects for insert
  with check (bucket_id = 'invoices' and is_admin());

create policy "invoices_admin_delete"
  on storage.objects for delete
  using (bucket_id = 'invoices' and is_admin());
