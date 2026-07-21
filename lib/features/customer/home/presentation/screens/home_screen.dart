import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../wishlist/presentation/providers/wishlist_providers.dart';
import '../providers/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final featured = ref.watch(featuredProductsProvider);
    final trending = ref.watch(trendingProductsProvider);
    final wishlisted = ref.watch(wishlistedProductIdsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.storefront_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('ShopHub'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () => context.push('/notifications')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(trendingProductsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: () => context.push('/search'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: AppColors.textSecondary),
                    SizedBox(width: 10),
                    Text('Search any Product...', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('50-40% OFF', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('New in (product)\nAll collections', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: 'Categories', onViewAll: () => context.push('/search')),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: categories.when(
                data: (list) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final c = list[i];
                    return GestureDetector(
                      onTap: () => context.push('/search?categoryId=${c.id}'),
                      child: SizedBox(
                        width: 72,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.background,
                              backgroundImage: c.imageUrl != null ? NetworkImage(c.imageUrl!) : null,
                              child: c.imageUrl == null ? const Icon(Icons.category_outlined, color: AppColors.textSecondary) : null,
                            ),
                            const SizedBox(height: 6),
                            Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(message: 'Could not load categories'),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: 'Featured', onViewAll: () => context.push('/search')),
            const SizedBox(height: 12),
            featured.when(
              data: (list) => list.isEmpty
                  ? const EmptyView(message: 'No featured products yet')
                  : _ProductGrid(products: list, wishlisted: wishlisted, ref: ref),
              loading: () => const Padding(padding: EdgeInsets.all(24), child: LoadingView()),
              error: (e, _) => const ErrorView(message: 'Could not load products'),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Trending Products'),
            const SizedBox(height: 12),
            trending.when(
              data: (list) => list.isEmpty
                  ? const EmptyView(message: 'No products yet — check back soon')
                  : _ProductGrid(products: list, wishlisted: wishlisted, ref: ref),
              loading: () => const Padding(padding: EdgeInsets.all(24), child: LoadingView()),
              error: (e, _) => const ErrorView(message: 'Could not load products'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.wishlisted, required this.ref});

  final List products;
  final Set<String> wishlisted;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, i) {
        final product = products[i];
        return ProductCard(
          product: product,
          onTap: () => context.push('/product/${product.id}'),
          isWishlisted: wishlisted.contains(product.id),
          onWishlistToggle: () => ref.read(wishlistControllerProvider.notifier).toggle(product.id),
        );
      },
    );
  }
}
