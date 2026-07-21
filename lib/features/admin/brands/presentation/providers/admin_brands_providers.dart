import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/config/supabase_config.dart';
import '../../../../../core/constants/supabase_tables.dart';
import '../../../../../shared/models/brand.dart';

final adminBrandsProvider = FutureProvider<List<Brand>>((ref) async {
  final rows = await SupabaseConfig.client.from(SupabaseTables.brands).select().order('name');
  return rows.map(Brand.fromJson).toList();
});

class AdminBrandActions {
  static Future<void> upsert(Map<String, dynamic> data, {String? id}) async {
    if (id == null) {
      await SupabaseConfig.client.from(SupabaseTables.brands).insert(data);
    } else {
      await SupabaseConfig.client.from(SupabaseTables.brands).update(data).eq('id', id);
    }
  }

  static Future<void> setActive(String id, bool isActive) async {
    await SupabaseConfig.client.from(SupabaseTables.brands).update({'is_active': isActive}).eq('id', id);
  }

  static Future<void> delete(String id) async {
    await SupabaseConfig.client.from(SupabaseTables.brands).delete().eq('id', id);
  }
}
