import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../shared/models/product.dart';
import '../../../../../shared/repositories/catalog_repository.dart';

class SearchQuery {
  const SearchQuery({this.text, this.categoryId, this.brandId});
  final String? text;
  final String? categoryId;
  final String? brandId;
}

final searchQueryProvider = StateProvider<SearchQuery>((ref) => const SearchQuery());

final searchResultsProvider = FutureProvider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(catalogRepositoryProvider).fetchProducts(
        search: query.text,
        categoryId: query.categoryId,
        brandId: query.brandId,
        activeOnly: true,
      );
});
