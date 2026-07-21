import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../domain/admin_review_actions.dart';
import '../providers/admin_reviews_providers.dart';

class AdminReviewsScreen extends ConsumerStatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  ConsumerState<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends ConsumerState<AdminReviewsScreen> {
  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(adminReviewsProvider(_selectedProductId));
    final productsAsync = ref.watch(adminProductsForReviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: PrimaryButton(
              label: 'Add Review',
              onPressed: () => context.go('/admin/reviews/new'),
              icon: Icons.add,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: productsAsync.when(
                    data: (products) => DropdownButtonFormField<String?>(
                      value: _selectedProductId,
                      decoration: const InputDecoration(labelText: 'Filter by Product', border: OutlineInputBorder()),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Products')),
                        ...products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))),
                      ],
                      onChanged: (v) => setState(() => _selectedProductId = v),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => const Text('Could not load products'),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
          Expanded(
            child: reviewsAsync.when(
              data: (reviews) {
                if (reviews.isEmpty) return const EmptyView(message: 'No reviews found.');
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: review.customerAvatar != null ? NetworkImage(review.customerAvatar!) : null,
                          child: review.customerAvatar == null ? const Icon(Icons.person) : null,
                        ),
                        title: Row(
                          children: [
                            Text(review.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            if (review.verifiedPurchase) const Icon(Icons.verified, color: Colors.blue, size: 16),
                            const Spacer(),
                            Row(
                              children: List.generate(5, (i) => Icon(
                                Icons.star, 
                                size: 16, 
                                color: i < review.rating ? Colors.amber : Colors.grey.shade300,
                              )),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (review.reviewTitle != null) Text(review.reviewTitle!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (review.reviewDescription != null) Text(review.reviewDescription!, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Text(formatDate(review.createdAt), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(review.status, style: const TextStyle(fontSize: 12)),
                              backgroundColor: review.status == 'Published' ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                              labelStyle: TextStyle(color: review.status == 'Published' ? Colors.green : Colors.red),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => context.go('/admin/reviews/${review.id}/edit'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    title: const Text('Delete Review?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await AdminReviewActions.deleteReview(review.id);
                                  ref.invalidate(adminReviewsProvider);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingView(),
              error: (e, _) => const ErrorView(message: 'Error loading reviews'),
            ),
          ),
        ],
      ),
    );
  }
}
