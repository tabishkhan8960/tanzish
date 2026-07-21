import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../wishlist/presentation/providers/wishlist_providers.dart';
import '../../reviews/presentation/providers/reviews_providers.dart';
import '../../../../../shared/widgets/review_card.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _imageIndex = 0;
  bool _addingToCart = false;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productProvider(widget.productId));

    return Scaffold(
      body: productAsync.when(
        data: (product) => _buildBody(context, product),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: 'Could not load product', onRetry: () => ref.invalidate(productProvider(widget.productId))),
      ),
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() => _addingToCart = true);
                      await ref.read(cartControllerProvider.notifier).add(product.id);
                      if (mounted) {
                        setState(() => _addingToCart = false);
                        messenger.showSnackBar(const SnackBar(content: Text('Added to cart')));
                      }
                    },
                    icon: _addingToCart ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Go to cart', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.touch_app),
                    label: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
        orElse: () => null,
      ),
    );
  }

  Widget _buildBody(BuildContext context, Product product) {
    final wishlisted = ref.watch(wishlistedProductIdsProvider).contains(product.id);
    final similar = ref.watch(similarProductsProvider(product));
    final images = product.images.isNotEmpty ? product.images : null;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 340,
          pinned: true,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          actions: [
            IconButton(
              icon: Icon(wishlisted ? Icons.favorite : Icons.favorite_border, color: wishlisted ? AppColors.primary : null),
              onPressed: () => ref.read(wishlistControllerProvider.notifier).toggle(product.id),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: images == null
                ? Container(color: AppColors.background, child: const Icon(Icons.image_outlined, size: 64, color: AppColors.textSecondary))
                : PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() => _imageIndex = i),
                    itemBuilder: (context, i) => CachedNetworkImage(imageUrl: images[i].imageUrl, fit: BoxFit.cover),
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((product.images.length) > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.images.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _imageIndex ? 16 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _imageIndex ? AppColors.primary : AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (product.attributes['sizes'] != null) ...[
                  const SizedBox(height: 20),
                  const Text('Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: (product.attributes['sizes'] as List).map((size) {
                      final isSelected = size == (product.attributes['sizes'] as List).first;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFD8397) : Colors.white,
                          border: Border.all(color: isSelected ? const Color(0xFFFD8397) : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          size.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (product.brand != null)
                  Text(product.brand!.name.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.rating, size: 18),
                    const SizedBox(width: 4),
                    Text('${product.ratingAvg.toStringAsFixed(1)} (${product.ratingCount} reviews)', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(formatCurrency(product.price), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    if (product.isOnSale) ...[
                      const SizedBox(width: 10),
                      Text(
                        formatCurrency(product.compareAtPrice!),
                        style: const TextStyle(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('${product.discountPercent}% Off', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ],
                ),
                if (product.description != null) ...[
                  const SizedBox(height: 20),
                  const Text('Product Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text(product.description!, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
                ],
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text('Customer Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(product.ratingAvg.toStringAsFixed(1), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < product.ratingAvg.round() ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 20,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Text('(${product.ratingCount} Reviews)', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 20),
                ref.watch(productReviewsProvider(product.id)).when(
                  data: (reviews) {
                    if (reviews.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No reviews yet. Be the first to review this product.', style: TextStyle(color: AppColors.textSecondary)),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...reviews.take(3).map((r) => ReviewCard(review: r)),
                        if (reviews.length > 3)
                          Center(
                            child: OutlinedButton(
                              onPressed: () => context.push('/product/${product.id}/reviews'),
                              child: const Text('View All Reviews'),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const LoadingView(),
                  error: (e, _) => const ErrorView(message: 'Could not load reviews'),
                ),
                const SizedBox(height: 24),
                similar.when(
                  data: (list) => list.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Similar Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 240,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: list.length,
                                separatorBuilder: (_, _) => const SizedBox(width: 12),
                                itemBuilder: (context, i) => SizedBox(
                                  width: 150,
                                  child: ProductCard(product: list[i], onTap: () => context.pushReplacement('/product/${list[i].id}')),
                                ),
                              ),
                            ),
                          ],
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
