import 'dart:io';
import 'dart:convert';
import '../lib/shared/mock_data/mock_catalog_data.dart';

String generateUuid(String seed) {
  return '00000000-0000-0000-0000-${seed.hashCode.toRadixString(16).padLeft(12, "0")}';
}

const key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFiY2RhdnZ3bHNpc3hjdmF1amZwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NDYzMTAyNywiZXhwIjoyMTAwMjA3MDI3fQ.BadBiNCc_PoNp2XOxw-z1hMMGadIeG--bHrL6ACIRQg';
const baseUrl = 'https://qbcdavvwlsisxcvaujfp.supabase.co/rest/v1';

Future<void> insertTable(String table, List<Map<String, dynamic>> rows) async {
  final client = HttpClient();
  final request = await client.postUrl(Uri.parse('$baseUrl/$table'));
  request.headers.add('apikey', key);
  request.headers.add('Authorization', 'Bearer $key');
  request.headers.add('Content-Type', 'application/json');
  request.headers.add('Prefer', 'return=minimal');
  
  request.add(utf8.encode(jsonEncode(rows)));
  final response = await request.close();
  
  print('Inserted ${rows.length} rows into $table: ${response.statusCode}');
  if (response.statusCode >= 400) {
    final body = await response.transform(utf8.decoder).join();
    print('Error: $body');
  }
  client.close();
}

void main() async {
  print('Starting upload to Supabase...');

  final categories = mockCategories.map((c) => {
    'id': generateUuid(c.id),
    'name': c.name,
    'slug': c.slug,
    'image_url': c.imageUrl,
    'sort_order': c.sortOrder,
    'is_active': true,
  }).toList();
  await insertTable('categories', categories);

  final brands = mockBrands.map((b) => {
    'id': generateUuid(b.id),
    'name': b.name,
    'slug': b.slug,
    'logo_url': b.logoUrl,
    'is_active': true,
  }).toList();
  await insertTable('brands', brands);

  final products = mockProducts.map((p) => {
    'id': generateUuid(p.id),
    'name': p.name,
    'slug': p.slug,
    'description': p.description,
    'brand_id': p.brandId != null ? generateUuid(p.brandId!) : null,
    'category_id': p.categoryId != null ? generateUuid(p.categoryId!) : null,
    'price': p.price,
    'compare_at_price': p.compareAtPrice,
    'attributes': p.attributes,
    'rating_avg': p.ratingAvg,
    'rating_count': p.ratingCount,
    'is_active': p.isActive,
    'is_featured': p.isFeatured,
  }).toList();
  await insertTable('products', products);

  final images = <Map<String, dynamic>>[];
  for (final p in mockProducts) {
    for (final img in p.images) {
      images.add({
        'id': generateUuid(img.id),
        'product_id': generateUuid(p.id),
        'image_url': img.imageUrl,
        'sort_order': img.sortOrder,
        'is_primary': img.isPrimary,
      });
    }
  }
  // Split images if too large, but 25*3=75 is small enough
  await insertTable('product_images', images);

  print('Upload complete!');
}
