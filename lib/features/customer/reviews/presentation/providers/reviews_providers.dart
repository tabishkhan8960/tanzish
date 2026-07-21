import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/supabase_config.dart';
import '../../../../../shared/models/review.dart';

final productReviewsProvider = FutureProvider.family<List<Review>, String>((ref, productId) async {
  final res = await SupabaseConfig.client
      .from('product_reviews')
      .select()
      .eq('product_id', productId)
      .eq('status', 'Published')
      .order('created_at', ascending: false);
  return res.map((e) => Review.fromJson(e)).toList();
});
