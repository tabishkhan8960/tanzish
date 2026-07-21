import 'dart:io';
import 'dart:convert';
import '../lib/shared/mock_data/mock_catalog_data.dart';

String generateUuid(String seed) {
  return '00000000-0000-0000-0000-${seed.hashCode.toRadixString(16).padLeft(12, "0")}';
}

void main() {
  final buffer = StringBuffer();
  buffer.writeln('-- Auto-generated seed data');
  buffer.writeln();

  String escape(String? s) {
    if (s == null) return 'NULL';
    final replaced = s.replaceAll("'", "''");
    return "'$replaced'";
  }

  // Generate Categories
  buffer.writeln('INSERT INTO categories (id, name, slug, image_url, sort_order) VALUES');
  final catRows = mockCategories.map((c) {
    return "('${generateUuid(c.id)}', ${escape(c.name)}, ${escape(c.slug)}, ${escape(c.imageUrl)}, ${c.sortOrder})";
  }).join(',\n');
  buffer.writeln(catRows + ';');
  buffer.writeln();

  // Generate Brands
  buffer.writeln('INSERT INTO brands (id, name, slug, logo_url) VALUES');
  final brandRows = mockBrands.map((b) {
    return "('${generateUuid(b.id)}', ${escape(b.name)}, ${escape(b.slug)}, ${escape(b.logoUrl)})";
  }).join(',\n');
  buffer.writeln(brandRows + ';');
  buffer.writeln();

  // Generate Products
  buffer.writeln('INSERT INTO products (id, name, slug, description, brand_id, category_id, price, compare_at_price, attributes, rating_avg, rating_count, is_active, is_featured) VALUES');
  final prodRows = mockProducts.map((p) {
    final bId = p.brandId != null ? "'${generateUuid(p.brandId!)}'" : 'NULL';
    final cId = p.categoryId != null ? "'${generateUuid(p.categoryId!)}'" : 'NULL';
    final attrs = escape(jsonEncode(p.attributes));
    return "('${generateUuid(p.id)}', ${escape(p.name)}, ${escape(p.slug)}, ${escape(p.description)}, $bId, $cId, ${p.price}, ${p.compareAtPrice ?? 'NULL'}, $attrs::jsonb, ${p.ratingAvg}, ${p.ratingCount}, ${p.isActive}, ${p.isFeatured})";
  }).join(',\n');
  buffer.writeln(prodRows + ';');
  buffer.writeln();

  // Generate Product Images
  buffer.writeln('INSERT INTO product_images (id, product_id, image_url, sort_order, is_primary) VALUES');
  final imageRows = <String>[];
  for (final p in mockProducts) {
    for (int i = 0; i < p.images.length; i++) {
      final img = p.images[i];
      imageRows.add("('${generateUuid(img.id)}', '${generateUuid(p.id)}', ${escape(img.imageUrl)}, ${img.sortOrder}, ${img.isPrimary})");
    }
  }
  buffer.writeln(imageRows.join(',\n') + ';');
  buffer.writeln();

  File('../admin/supabase/migrations/0005_seed_dummy_data.sql').writeAsStringSync(buffer.toString());
  print('Generated 0005_seed_dummy_data.sql successfully!');
}
