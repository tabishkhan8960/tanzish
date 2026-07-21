import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/review.dart';

/// A product row plus its images/brand/category, ready for display.
const productSelect = '*, brand:brands(*), category:categories(*), product_images(*)';

class CatalogRepository {
  CatalogRepository(this._client);

  final SupabaseClient _client;

  Future<List<Category>> fetchCategories({bool activeOnly = true}) async {
    var query = _client.from(SupabaseTables.categories).select();
    if (activeOnly) query = query.eq('is_active', true);
    final rows = await query.order('sort_order');
    return rows.map(Category.fromJson).toList();
  }

  Future<List<Brand>> fetchBrands({bool activeOnly = true}) async {
    var query = _client.from(SupabaseTables.brands).select();
    if (activeOnly) query = query.eq('is_active', true);
    final rows = await query.order('name');
    return rows.map(Brand.fromJson).toList();
  }

  Future<List<Product>> fetchProducts({
    String? categoryId,
    String? brandId,
    String? search,
    bool featuredOnly = false,
    bool activeOnly = true,
    int limit = 30,
    int offset = 0,
  }) async {
    var query = _client.from(SupabaseTables.products).select(productSelect);
    if (activeOnly) query = query.eq('is_active', true);
    if (categoryId != null) query = query.eq('category_id', categoryId);
    if (brandId != null) query = query.eq('brand_id', brandId);
    if (featuredOnly) query = query.eq('is_featured', true);
    if (search != null && search.trim().isNotEmpty) {
      query = query.ilike('name', '%${search.trim()}%');
    }
    final rows = await query.order('created_at', ascending: false).range(offset, offset + limit - 1);
    return rows.map(Product.fromJson).toList();
  }

  Future<Product> fetchProduct(String id) async {
    final row = await _client.from(SupabaseTables.products).select(productSelect).eq('id', id).single();
    return Product.fromJson(row);
  }

  Future<List<Product>> fetchSimilarProducts(Product product, {int limit = 10}) async {
    final rows = await _client
        .from(SupabaseTables.products)
        .select(productSelect)
        .eq('is_active', true)
        .eq('category_id', product.categoryId ?? '')
        .neq('id', product.id)
        .limit(limit);
    return rows.map(Product.fromJson).toList();
  }

  Future<List<Review>> fetchReviews(String productId) async {
    final rows = await _client
        .from(SupabaseTables.reviews)
        .select('*, profile:profiles(*)')
        .eq('product_id', productId)
        .eq('is_approved', true)
        .order('created_at', ascending: false);
    return rows.map(Review.fromJson).toList();
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(SupabaseConfig.client);
});
