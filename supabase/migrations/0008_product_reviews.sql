CREATE TABLE product_reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  customer_name TEXT NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_title TEXT,
  review_description TEXT,
  customer_avatar TEXT,
  verified_purchase BOOLEAN DEFAULT false,
  status TEXT DEFAULT 'Published' CHECK (status IN ('Published', 'Hidden')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE product_reviews ENABLE ROW LEVEL SECURITY;

-- Allow public read access to published reviews
CREATE POLICY "Public reviews are viewable by everyone." 
  ON product_reviews FOR SELECT USING (status = 'Published');

-- Allow admins full access
CREATE POLICY "Admins can do everything on product_reviews." 
  ON product_reviews FOR ALL USING (
    EXISTS (SELECT 1 FROM auth.users WHERE auth.users.id = auth.uid() AND auth.users.raw_user_meta_data->>'role' = 'admin')
  );

-- Trigger to update product rating_avg and rating_count
CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    UPDATE products
    SET 
      rating_avg = (SELECT ROUND(AVG(rating)::numeric, 1) FROM product_reviews WHERE product_id = NEW.product_id AND status = 'Published'),
      rating_count = (SELECT COUNT(*) FROM product_reviews WHERE product_id = NEW.product_id AND status = 'Published')
    WHERE id = NEW.product_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE products
    SET 
      rating_avg = COALESCE((SELECT ROUND(AVG(rating)::numeric, 1) FROM product_reviews WHERE product_id = OLD.product_id AND status = 'Published'), 0),
      rating_count = (SELECT COUNT(*) FROM product_reviews WHERE product_id = OLD.product_id AND status = 'Published')
    WHERE id = OLD.product_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_product_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON product_reviews
FOR EACH ROW
EXECUTE FUNCTION update_product_rating();
