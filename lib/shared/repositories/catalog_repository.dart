import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/data_mode.dart';
import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../mock_data/mock_catalog_repository.dart';
import '../models/brand.dart';
import '../models/category.dart';
import '../models/inventory_item.dart';
import '../models/product.dart';
import '../models/review.dart';

/// A product row plus its images/brand/category, ready for display.
const productSelect = '*, brand:brands(*), category:categories(*), product_images(*)';

/// Everything the UI needs from the product catalog. [SupabaseCatalogRepository]
/// is the real, live-backend implementation; [MockCatalogRepository] is a
/// drop-in stand-in backed by static in-memory data (see
/// `lib/shared/mock_data/`) for development before the backend has real
/// products. `catalogRepositoryProvider` below is the single place that
/// decides which one the whole app gets — no screen or provider talks to
/// either implementation directly, so flipping [kUseMockCatalogData] back to
/// `false` is the entire migration back to live data.
abstract class CatalogRepository {
  Future<List<Category>> fetchCategories({bool activeOnly = true});

  Future<List<Brand>> fetchBrands({bool activeOnly = true});

  Future<List<Product>> fetchProducts({
    String? categoryId,
    String? brandId,
    String? search,
    bool featuredOnly = false,
    bool activeOnly = true,
    int limit = 30,
    int offset = 0,
  });

  Future<Product> fetchProduct(String id);

  Future<List<Product>> fetchSimilarProducts(Product product, {int limit = 10});

  Future<List<Review>> fetchReviews(String productId);

  /// The purchasable variants (size/color/etc.) for a product, e.g. one row
  /// per {"Size": "M", "Color": "Red"} combination with its own stock count.
  Future<List<InventoryItem>> fetchInventory(String productId);

  /// A single standout on-sale product to headline a "Deal of the Day"
  /// section. Null if nothing qualifies (e.g. no featured product currently
  /// has a compare-at price set).
  Future<Product?> fetchDealOfTheDay();

  /// A general-purpose "you might like this" list, independent of the
  /// featured/trending selections (currently ranked by rating).
  Future<List<Product>> fetchRecommendedProducts({int limit = 10});
}

class SupabaseCatalogRepository implements CatalogRepository {
  SupabaseCatalogRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Category>> fetchCategories({bool activeOnly = true}) async {
    var query = _client.from(SupabaseTables.categories).select();
    if (activeOnly) query = query.eq('is_active', true);
    final rows = await query.order('sort_order');
    return rows.map(Category.fromJson).toList();
  }

  @override
  Future<List<Brand>> fetchBrands({bool activeOnly = true}) async {
    var query = _client.from(SupabaseTables.brands).select();
    if (activeOnly) query = query.eq('is_active', true);
    final rows = await query.order('name');
    return rows.map(Brand.fromJson).toList();
  }

  @override
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

  @override
  Future<Product> fetchProduct(String id) async {
    final row = await _client.from(SupabaseTables.products).select(productSelect).eq('id', id).single();
    return Product.fromJson(row);
  }

  @override
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

  @override
  Future<List<Review>> fetchReviews(String productId) async {
    final rows = await _client
        .from(SupabaseTables.reviews)
        .select('*, profile:profiles(*)')
        .eq('product_id', productId)
        .eq('is_approved', true)
        .order('created_at', ascending: false);
    return rows.map(Review.fromJson).toList();
  }

  @override
  Future<List<InventoryItem>> fetchInventory(String productId) async {
    final rows = await _client.from(SupabaseTables.inventory).select().eq('product_id', productId);
    return rows.map(InventoryItem.fromJson).toList();
  }

  @override
  Future<Product?> fetchDealOfTheDay() async {
    final rows = await _client
        .from(SupabaseTables.products)
        .select(productSelect)
        .eq('is_active', true)
        .eq('is_featured', true)
        .not('compare_at_price', 'is', null)
        .order('created_at', ascending: false)
        .limit(1);
    if (rows.isEmpty) return null;
    return Product.fromJson(rows.first);
  }

  @override
  Future<List<Product>> fetchRecommendedProducts({int limit = 10}) async {
    final rows = await _client
        .from(SupabaseTables.products)
        .select(productSelect)
        .eq('is_active', true)
        .order('rating_avg', ascending: false)
        .limit(limit);
    return rows.map(Product.fromJson).toList();
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  if (kUseMockCatalogData) return MockCatalogRepository();
  return SupabaseCatalogRepository(SupabaseConfig.client);
});
