import '../../../../core/config/supabase_config.dart';
import '../../../../shared/models/review.dart';

class AdminReviewActions {
  static const _table = 'product_reviews';

  static Future<Map<String, dynamic>> fetchById(String id) async {
    return await SupabaseConfig.client.from(_table).select().eq('id', id).single();
  }

  static Future<void> createReview(Map<String, dynamic> data) async {
    await SupabaseConfig.client.from(_table).insert(data);
  }

  static Future<void> updateReview(String id, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    await SupabaseConfig.client.from(_table).update(data).eq('id', id);
  }

  static Future<void> deleteReview(String id) async {
    await SupabaseConfig.client.from(_table).delete().eq('id', id);
  }

  static Future<void> toggleStatus(String id, String currentStatus) async {
    final newStatus = currentStatus == 'Published' ? 'Hidden' : 'Published';
    await updateReview(id, {'status': newStatus});
  }
}
