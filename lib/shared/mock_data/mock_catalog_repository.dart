import '../models/brand.dart';
import '../models/category.dart';
import '../models/inventory_item.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repositories/catalog_repository.dart';
import 'mock_catalog_data.dart';

/// Development-time stand-in for [SupabaseCatalogRepository], backed by the
/// static data in `mock_catalog_data.dart`. See `core/config/data_mode.dart`
/// for how the app picks between the two — nothing in this class is
/// referenced directly by any screen, only through the shared
/// [CatalogRepository] interface via `catalogRepositoryProvider`.
class MockCatalogRepository implements CatalogRepository {
  static final _brandsById = {for (final b in mockBrands) b.id: b};
  static final _categoriesById = {for (final c in mockCategories) c.id: c};

  /// Attaches the embedded `brand`/`category` objects the same way the real
  /// repository's `product_images(*)` join does, so the UI never has to
  /// know whether it's looking at mock or live data.
  Product _hydrate(Product p) {
    return p.copyWith(
      brand: p.brandId == null ? null : _brandsById[p.brandId],
      category: p.categoryId == null ? null : _categoriesById[p.categoryId],
    );
  }

  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 250));

  @override
  Future<List<Category>> fetchCategories({bool activeOnly = true}) async {
    await _simulateLatency();
    final categories = activeOnly ? mockCategories.where((c) => c.isActive) : mockCategories;
    return categories.sortedBySortOrder;
  }

  @override
  Future<List<Brand>> fetchBrands({bool activeOnly = true}) async {
    await _simulateLatency();
    final brands = activeOnly ? mockBrands.where((b) => b.isActive) : mockBrands;
    return brands.toList()..sort((a, b) => a.name.compareTo(b.name));
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
    await _simulateLatency();
    var results = mockProducts.where((p) {
      if (activeOnly && !p.isActive) return false;
      if (categoryId != null && p.categoryId != categoryId) return false;
      if (brandId != null && p.brandId != brandId) return false;
      if (featuredOnly && !p.isFeatured) return false;
      if (search != null && search.trim().isNotEmpty) {
        if (!p.name.toLowerCase().contains(search.trim().toLowerCase())) return false;
      }
      return true;
    }).toList();

    if (offset >= results.length) return [];
    results = results.skip(offset).take(limit).toList();
    return results.map(_hydrate).toList();
  }

  @override
  Future<Product> fetchProduct(String id) async {
    await _simulateLatency();
    final product = mockProducts.where((p) => p.id == id).firstOrNull;
    if (product == null) throw StateError('Product $id not found in mock catalog');
    return _hydrate(product);
  }

  @override
  Future<List<Product>> fetchSimilarProducts(Product product, {int limit = 10}) async {
    await _simulateLatency();
    final results = mockProducts
        .where((p) => p.isActive && p.categoryId == product.categoryId && p.id != product.id)
        .take(limit)
        .map(_hydrate)
        .toList();
    return results;
  }

  @override
  Future<List<Review>> fetchReviews(String productId) async {
    await _simulateLatency();
    const reviewers = ['Aanya S.', 'Rohan K.', 'Priya M.', 'Daniel T.', 'Sara W.'];
    const comments = [
      'Exactly as described, great quality for the price.',
      'Fits perfectly and looks even better in person.',
      'Fast delivery, well packaged, would buy again.',
      "Good value, though I'd size up if you're between sizes.",
      'Love it — matches the photos exactly.',
    ];
    return [
      for (var i = 0; i < 3; i++)
        Review(
          id: '$productId-review-$i',
          productId: productId,
          customerName: reviewers[(productId.hashCode + i).abs() % reviewers.length],
          rating: 4 + (i % 2),
          reviewDescription: comments[(productId.hashCode + i).abs() % comments.length],
          verifiedPurchase: true,
          createdAt: DateTime.now().subtract(Duration(days: 3 + i * 11)),
          updatedAt: DateTime.now().subtract(Duration(days: 3 + i * 11)),
        ),
    ];
  }

  @override
  Future<List<InventoryItem>> fetchInventory(String productId) async {
    await _simulateLatency();
    return const [];
  }

  @override
  Future<Product?> fetchDealOfTheDay() async {
    await _simulateLatency();
    final onSaleFeatured = mockProducts.where((p) => p.isActive && p.isFeatured && p.compareAtPrice != null).toList()
      ..sort((a, b) => (b.discountPercent ?? 0).compareTo(a.discountPercent ?? 0));
    if (onSaleFeatured.isEmpty) return null;
    return _hydrate(onSaleFeatured.first);
  }

  @override
  Future<List<Product>> fetchRecommendedProducts({int limit = 10}) async {
    await _simulateLatency();
    final results = mockProducts.where((p) => p.isActive).toList()..sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
    return results.take(limit).map(_hydrate).toList();
  }
}

extension on Iterable<Category> {
  List<Category> get sortedBySortOrder => toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
