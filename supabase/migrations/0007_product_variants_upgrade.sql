-- Upgrade inventory table to act as a robust product_variants table
ALTER TABLE inventory
  ADD COLUMN IF NOT EXISTS price numeric(12,2) check (price >= 0),
  ADD COLUMN IF NOT EXISTS compare_at_price numeric(12,2) check (compare_at_price >= 0),
  ADD COLUMN IF NOT EXISTS sku text,
  ADD COLUMN IF NOT EXISTS barcode text,
  ADD COLUMN IF NOT EXISTS weight_grams numeric(12,2) check (weight_grams >= 0),
  ADD COLUMN IF NOT EXISTS image_urls text[] not null default '{}';
