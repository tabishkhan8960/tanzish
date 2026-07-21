import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/review.dart';

class ReviewRepository {
  ReviewRepository(this._client);

  final SupabaseClient _client;

  Future<List<Review>> fetchAll({bool? approvedOnly}) async {
    var query = _client.from(SupabaseTables.reviews).select('*, profile:profiles(*)');
    if (approvedOnly != null) query = query.eq('is_approved', approvedOnly);
    final rows = await query.order('created_at', ascending: false);
    return rows.map(Review.fromJson).toList();
  }

  Future<void> setApproved(String id, bool approved) async {
    await _client.from(SupabaseTables.reviews).update({'is_approved': approved}).eq('id', id);
  }

  Future<void> delete(String id) async {
    await _client.from(SupabaseTables.reviews).delete().eq('id', id);
  }

  Future<void> submit({
    required String productId,
    required String userId,
    required int rating,
    String? comment,
    String? orderItemId,
  }) async {
    await _client.from(SupabaseTables.reviews).insert({
      'product_id': productId,
      'user_id': userId,
      'order_item_id': orderItemId,
      'rating': rating,
      'comment': comment,
    });
  }
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(SupabaseConfig.client);
});
