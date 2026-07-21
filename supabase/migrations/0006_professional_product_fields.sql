-- Add professional ecommerce fields to products table
ALTER TABLE products 
  ADD COLUMN IF NOT EXISTS cost_price numeric(12,2) check (cost_price >= 0),
  ADD COLUMN IF NOT EXISTS barcode text,
  ADD COLUMN IF NOT EXISTS weight_grams numeric(12,2) check (weight_grams >= 0);
