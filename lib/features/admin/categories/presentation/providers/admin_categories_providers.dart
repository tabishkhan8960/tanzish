import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/config/supabase_config.dart';
import '../../../../../core/constants/supabase_tables.dart';
import '../../../../../shared/models/category.dart';

final adminCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final rows = await SupabaseConfig.client.from(SupabaseTables.categories).select().order('sort_order');
  return rows.map(Category.fromJson).toList();
});

class AdminCategoryActions {
  static Future<void> upsert(Map<String, dynamic> data, {String? id}) async {
    if (id == null) {
      await SupabaseConfig.client.from(SupabaseTables.categories).insert(data);
    } else {
      await SupabaseConfig.client.from(SupabaseTables.categories).update(data).eq('id', id);
    }
  }

  static Future<void> setActive(String id, bool isActive) async {
    await SupabaseConfig.client.from(SupabaseTables.categories).update({'is_active': isActive}).eq('id', id);
  }

  static Future<void> delete(String id) async {
    await SupabaseConfig.client.from(SupabaseTables.categories).delete().eq('id', id);
  }
}
