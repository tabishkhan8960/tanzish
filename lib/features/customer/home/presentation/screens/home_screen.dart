import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../wishlist/presentation/providers/wishlist_providers.dart';
import '../providers/home_providers.dart';
import '../../../../../shared/models/product.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final featured = ref.watch(featuredProductsProvider);
    final trending = ref.watch(trendingProductsProvider);
    final recommended = ref.watch(recommendedProductsProvider);
    final wishlisted = ref.watch(wishlistedProductIdsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [AppColors.primary, Colors.blue]),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text('Stylish', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'), // Dummy profile
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(trendingProductsProvider);
          ref.invalidate(recommendedProductsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textSecondary),
                      SizedBox(width: 10),
                      Text('Search any Product..', style: TextStyle(color: AppColors.textSecondary)),
                      Spacer(),
                      Icon(Icons.mic, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'All Featured', onViewAll: () => context.push('/search')),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: categories.when(
                data: (list) => ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, i) {
                    final c = list[i];
                    return GestureDetector(
                      onTap: () => context.push('/search?categoryId=${c.id}'),
                      child: SizedBox(
                        width: 65,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade200, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.surface,
                                backgroundImage: c.imageUrl != null ? NetworkImage(c.imageUrl!) : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Could not load categories'),
              ),
            ),
            const SizedBox(height: 24),
            
            // Promo Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFD8397), Color(0xFFF37878)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('50-40% OFF', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Now in (product)\nAll colours', style: TextStyle(color: Colors.white, fontSize: 12)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Shop Now →', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.network('https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400&q=80', fit: BoxFit.cover, height: 100),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Deal of the Day
            Container(
              color: Colors.blue.shade500,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Deal of the Day', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('⏱ 22h 55m 20s remaining', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('View all →', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: trending.when(
                data: (list) => _ProductGrid(products: list.take(2).toList(), wishlisted: wishlisted, ref: ref),
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Error'),
              ),
            ),
            const SizedBox(height: 24),
            
            // Special Offers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.network('https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=100&q=80', width: 60, height: 60, fit: BoxFit.cover),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Special Offers 🎁', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 4),
                          Text('We make sure you get the offer you need at best prices', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Trending Products header
            Container(
              color: const Color(0xFFFD8397),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Trending Products', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('📅 Last Date 29/02/22', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('View all →', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: featured.when(
                data: (list) => _ProductGrid(products: list.take(2).toList(), wishlisted: wishlisted, ref: ref),
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Error'),
              ),
            ),
            const SizedBox(height: 24),

            // Featured Products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const SectionHeader(title: 'Featured Products'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: featured.when(
                data: (list) => _ProductGrid(products: list.skip(2).take(4).toList(), wishlisted: wishlisted, ref: ref),
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Error'),
              ),
            ),
            const SizedBox(height: 24),

            // Recommended Products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const SectionHeader(title: 'Recommended Products'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: recommended.when(
                data: (list) => _ProductGrid(products: list, wishlisted: wishlisted, ref: ref),
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Error'),
              ),
            ),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.wishlisted, required this.ref});

  final List<Product> products;
  final Set<String> wishlisted;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.58, // Adjusted for taller cards
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
