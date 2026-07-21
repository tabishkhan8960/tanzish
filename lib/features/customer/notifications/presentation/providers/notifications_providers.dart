import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/config/supabase_config.dart';
import '../../../../../core/constants/supabase_tables.dart';
import '../../../../../shared/models/notification_item.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

final notificationsProvider = FutureProvider<List<NotificationItem>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  final rows = await SupabaseConfig.client
      .from(SupabaseTables.notifications)
      .select()
      .eq('user_id', userId)
      .order('created_at', ascending: false);
  return rows.map(NotificationItem.fromJson).toList();
});

Future<void> markNotificationRead(String id) {
  return SupabaseConfig.client.from(SupabaseTables.notifications).update({'is_read': true}).eq('id', id);
}
