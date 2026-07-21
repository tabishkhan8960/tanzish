import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/brand.dart';
import '../../../../../shared/models/category.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../shared/repositories/catalog_repository.dart';
import '../../../../../core/config/supabase_config.dart';
import '../../../../../core/constants/supabase_tables.dart';

String? _storagePathFromPublicUrl(String url) {
  const marker = '/object/public/${SupabaseBuckets.productImages}/';
  final i = url.indexOf(marker);
  if (i == -1) return null;
  return url.substring(i + marker.length);
}

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

final productProvider = FutureProvider.family<Product, String>((ref, id) {
  return ref.watch(catalogRepositoryProvider).fetchProduct(id);
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
    final oldRows = await SupabaseConfig.client.from(SupabaseTables.productImages).select('image_url').eq('product_id', productId);
    final oldUrls = oldRows.map((r) => r['image_url'] as String).toSet();
    final orphaned = oldUrls.difference(urls.toSet());
    final orphanedPaths = orphaned.map(_storagePathFromPublicUrl).whereType<String>().toList();

    await SupabaseConfig.client.from(SupabaseTables.productImages).delete().eq('product_id', productId);
    if (urls.isNotEmpty) {
      await SupabaseConfig.client.from(SupabaseTables.productImages).insert([
        for (var i = 0; i < urls.length; i++) {'product_id': productId, 'image_url': urls[i], 'sort_order': i, 'is_primary': i == 0},
      ]);
    }

    if (orphanedPaths.isNotEmpty) {
      try {
        await SupabaseConfig.client.storage.from(SupabaseBuckets.productImages).remove(orphanedPaths);
      } catch (_) {
        // Best-effort: an orphaned Storage object is preferable to blocking
        // the product save on a cleanup failure.
      }
    }
  }
}
