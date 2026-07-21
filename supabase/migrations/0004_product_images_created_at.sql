-- product_images was missing created_at (needed for the admin image-upload
-- feature's audit trail / ordering-by-recency).
alter table product_images
  add column if not exists created_at timestamptz not null default now();
