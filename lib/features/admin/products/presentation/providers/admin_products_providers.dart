import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/brand.dart';
import '../../../../../shared/models/category.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../shared/repositories/catalog_repository.dart';
import '../../../../../core/config/supabase_config.dart';
import '../../../../../core/constants/supabase_tables.dart';

final adminProductsSearchProvider = StateProvider<String>((ref) => '');

final adminProductsProvider = FutureProvider<List<Product>>((ref) {
  final search = ref.watch(adminProductsSearchProvider);
  return ref.watch(catalogRepositoryProvider).fetchProducts(activeOnly: false, search: search.isEmpty ? null : search, limit: 200);
});

final adminAllCategoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchCategories(activeOnly: false);
});

final adminAllBrandsProvider = FutureProvider<List<Brand>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchBrands(activeOnly: false);
});

class AdminProductActions {
  static Future<String> upsert(Map<String, dynamic> data, {String? id}) async {
    if (id == null) {
      final row = await SupabaseConfig.client.from(SupabaseTables.products).insert(data).select().single();
      return row['id'] as String;
    }
    await SupabaseConfig.client.from(SupabaseTables.products).update(data).eq('id', id);
    return id;
  }

  static Future<void> setActive(String id, bool isActive) async {
    await SupabaseConfig.client.from(SupabaseTables.products).update({'is_active': isActive}).eq('id', id);
  }

  static Future<void> delete(String id) async {
    await SupabaseConfig.client.from(SupabaseTables.products).delete().eq('id', id);
  }

  static Future<void> replaceImages(String productId, List<String> urls) async {
    await SupabaseConfig.client.from(SupabaseTables.productImages).delete().eq('product_id', productId);
    if (urls.isEmpty) return;
    await SupabaseConfig.client.from(SupabaseTables.productImages).insert([
      for (var i = 0; i < urls.length; i++) {'product_id': productId, 'image_url': urls[i], 'sort_order': i, 'is_primary': i == 0},
    ]);
  }
}
