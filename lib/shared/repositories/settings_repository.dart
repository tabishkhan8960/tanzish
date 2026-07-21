import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';

class SettingsRepository {
  SettingsRepository(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>> fetchAll() async {
    final rows = await _client.from(SupabaseTables.settings).select();
    return {for (final row in rows) row['key'] as String: row['value']};
  }

  Future<void> set(String key, dynamic value) async {
    await _client.from(SupabaseTables.settings).upsert({'key': key, 'value': value});
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(SupabaseConfig.client);
});
