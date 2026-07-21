import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/repositories/review_repository.dart';

final adminReviewsProvider = FutureProvider((ref) {
  return ref.watch(reviewRepositoryProvider).fetchAll();
});

class AdminReviewsScreen extends ConsumerWidget {
  const AdminReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(adminReviewsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Reviews')),
      body: reviewsAsync.when(
        data: (reviews) => reviews.isEmpty
            ? const EmptyView(message: 'No reviews yet', icon: Icons.reviews_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final r = reviews[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.background,
                      child: Text(r.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    title: Row(
                      children: [
                        Text(r.profile?.fullName ?? 'Customer', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(5, (i) => Icon(i < r.rating ? Icons.star_rounded : Icons.star_border_rounded, size: 14, color: AppColors.rating)),
                        ),
                      ],
                    ),
                    subtitle: Text(r.comment ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(r.isApproved ? 'Approved' : 'Pending', style: const TextStyle(fontSize: 11)),
                          backgroundColor: (r.isApproved ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
                          labelStyle: TextStyle(color: r.isApproved ? AppColors.success : AppColors.warning),
                        ),
                        IconButton(
                          icon: Icon(r.isApproved ? Icons.visibility_off_outlined : Icons.check_circle_outline, size: 20),
                          tooltip: r.isApproved ? 'Unapprove' : 'Approve',
                          onPressed: () async {
                            await ref.read(reviewRepositoryProvider).setApproved(r.id, !r.isApproved);
                            ref.invalidate(adminReviewsProvider);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          onPressed: () async {
                            await ref.read(reviewRepositoryProvider).delete(r.id);
                            ref.invalidate(adminReviewsProvider);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load reviews'),
      ),
    );
  }
}
