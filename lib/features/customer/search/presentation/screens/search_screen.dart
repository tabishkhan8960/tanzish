import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../../../wishlist/presentation/providers/wishlist_providers.dart';
import '../providers/search_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.categoryId != null) {
        ref.read(searchQueryProvider.notifier).state = SearchQuery(categoryId: widget.categoryId);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final wishlisted = ref.watch(wishlistedProductIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: widget.categoryId == null,
          decoration: const InputDecoration(hintText: 'Search any Product...', border: InputBorder.none),
          onSubmitted: (v) => ref.read(searchQueryProvider.notifier).state = SearchQuery(text: v),
        ),
      ),
      body: results.when(
        data: (products) => products.isEmpty
            ? const EmptyView(message: 'No products found', icon: Icons.search_off)
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, i) {
                  final p = products[i];
                  return ProductCard(
                    product: p,
                    onTap: () => context.push('/product/${p.id}'),
                    isWishlisted: wishlisted.contains(p.id),
                    onWishlistToggle: () => ref.read(wishlistControllerProvider.notifier).toggle(p.id),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Something went wrong'),
      ),
    );
  }
}
