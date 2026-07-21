import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.border,
                backgroundImage: review.customerAvatar != null ? NetworkImage(review.customerAvatar!) : null,
                child: review.customerAvatar == null ? const Icon(Icons.person, color: AppColors.textSecondary) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(review.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        if (review.verifiedPurchase) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Colors.blue, size: 14),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) => Icon(
                          index < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 14,
                        )),
                        const SizedBox(width: 8),
                        Text(formatDate(review.createdAt), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.reviewTitle != null || review.reviewDescription != null) ...[
            const SizedBox(height: 12),
            if (review.reviewTitle != null)
              Text(review.reviewTitle!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            if (review.reviewTitle != null && review.reviewDescription != null) const SizedBox(height: 4),
            if (review.reviewDescription != null)
              Text(review.reviewDescription!, style: const TextStyle(color: AppColors.textPrimary, height: 1.4)),
          ],
        ],
      ),
    );
  }
}
