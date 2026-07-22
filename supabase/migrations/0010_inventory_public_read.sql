-- inventory was admin-only for every operation, which blocked shoppers from
-- ever reading variant data (e.g. size/color options) for a product — the
-- customer app has no way to know what sizes exist without this. Split into
-- public read (active products only) + admin-only write, matching the same
-- pattern already used for products/categories/brands.

DROP POLICY IF EXISTS "inventory_admin_all" ON inventory;

CREATE POLICY "inventory_public_read"
  ON inventory FOR SELECT
  USING (
    is_admin() OR EXISTS (
      SELECT 1 FROM products WHERE products.id = inventory.product_id AND products.is_active
    )
  );

CREATE POLICY "inventory_admin_insert"
  ON inventory FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "inventory_admin_update"
  ON inventory FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "inventory_admin_delete"
  ON inventory FOR DELETE
  USING (is_admin());
