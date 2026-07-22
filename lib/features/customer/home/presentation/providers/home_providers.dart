import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/models/brand.dart';
import '../../../../../shared/models/category.dart';
import '../../../../../shared/models/inventory_item.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../shared/repositories/catalog_repository.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchCategories();
});

final brandsProvider = FutureProvider<List<Brand>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchBrands();
});

final featuredProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchProducts(featuredOnly: true, limit: 10);
});

final trendingProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchProducts(limit: 20);
});

final dealOfTheDayProvider = FutureProvider<Product?>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchDealOfTheDay();
});

final recommendedProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchRecommendedProducts(limit: 10);
});

final productProvider = FutureProvider.family<Product, String>((ref, id) {
  return ref.watch(catalogRepositoryProvider).fetchProduct(id);
});

final productInventoryProvider = FutureProvider.family<List<InventoryItem>, String>((ref, productId) {
  return ref.watch(catalogRepositoryProvider).fetchInventory(productId);
});

final similarProductsProvider = FutureProvider.family<List<Product>, Product>((ref, product) {
  return ref.watch(catalogRepositoryProvider).fetchSimilarProducts(product);
});
