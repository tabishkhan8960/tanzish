import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/supabase_config.dart';
import '../../../../../shared/models/review.dart';
import '../../../../../shared/models/product.dart';

final adminReviewsProvider = FutureProvider.family<List<Review>, String?>((ref, productId) async {
  var query = SupabaseConfig.client.from('product_reviews').select().order('created_at', ascending: false);
  if (productId != null && productId.isNotEmpty) {
    query = query.eq('product_id', productId);
  }
  final res = await query;
  return res.map((e) => Review.fromJson(e)).toList();
});

final adminProductsForReviewProvider = FutureProvider<List<Product>>((ref) async {
  final res = await SupabaseConfig.client.from('products').select('id, name').order('created_at', ascending: false);
  return res.map((e) => Product.fromJson(e)).toList();
});
