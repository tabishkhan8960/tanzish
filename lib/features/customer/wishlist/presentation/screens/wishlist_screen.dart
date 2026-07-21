import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../providers/wishlist_providers.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlistAsync.when(
        data: (items) => items.isEmpty
            ? const EmptyView(message: 'Save products you love here', icon: Icons.favorite_border)
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, i) {
                  final item = items[i];
                  if (item.product == null) return const SizedBox.shrink();
                  return ProductCard(
                    product: item.product!,
                    isWishlisted: true,
                    onTap: () => context.push('/product/${item.productId}'),
                    onWishlistToggle: () => ref.read(wishlistControllerProvider.notifier).toggle(item.productId),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load wishlist'),
      ),
    );
  }
}
