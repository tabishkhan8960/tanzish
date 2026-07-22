-- The original admin policy on product_reviews checked auth.users directly,
-- which the authenticated role has no SELECT grant on ("permission denied
-- for table users", 42501). Admin identity is tracked via profiles.role
-- everywhere else in the schema, via the security-definer is_admin() helper.

DROP POLICY IF EXISTS "Admins can do everything on product_reviews." ON product_reviews;

CREATE POLICY "product_reviews_admin_all"
  ON product_reviews FOR ALL
  USING (is_admin())
  WITH CHECK (is_admin());
