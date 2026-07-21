import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/review_card.dart';
import '../providers/reviews_providers.dart';

class ProductReviewsScreen extends ConsumerWidget {
  const ProductReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(productReviewsProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Reviews')),
      body: reviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) return const EmptyView(message: 'No reviews found.');
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reviews.length,
            itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
          );
        },
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load reviews'),
      ),
    );
  }
}
