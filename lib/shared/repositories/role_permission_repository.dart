import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../models/profile.dart';
import '../models/role_permission.dart';

class RolePermissionRepository {
  RolePermissionRepository(this._client);

  final SupabaseClient _client;

  Future<List<RolePermission>> fetchAll() async {
    final rows = await _client.from('role_permissions').select().order('role');
    return rows.map(RolePermission.fromJson).toList();
  }

  Future<void> setAllowed({required AppRole role, required String permission, required bool allowed}) async {
    await _client
        .from('role_permissions')
        .update({'allowed': allowed})
        .eq('role', role.dbValue)
        .eq('permission', permission);
  }
}

final rolePermissionRepositoryProvider = Provider<RolePermissionRepository>((ref) {
  return RolePermissionRepository(SupabaseConfig.client);
});
