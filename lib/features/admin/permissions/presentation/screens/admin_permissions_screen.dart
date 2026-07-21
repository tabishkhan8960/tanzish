import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/profile.dart';
import '../../../../../shared/models/role_permission.dart';
import '../../../../../shared/repositories/role_permission_repository.dart';

final adminPermissionsProvider = FutureProvider<List<RolePermission>>((ref) {
  return ref.watch(rolePermissionRepositoryProvider).fetchAll();
});

class AdminPermissionsScreen extends ConsumerWidget {
  const AdminPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionsAsync = ref.watch(adminPermissionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Control Authority')),
      body: permissionsAsync.when(
        data: (permissions) {
          final byRole = <AppRole, List<RolePermission>>{};
          for (final p in permissions) {
            byRole.putIfAbsent(p.role, () => []).add(p);
          }
          final roles = byRole.keys.toList()..sort((a, b) => a.label.compareTo(b.label));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final role in roles)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(role.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const Divider(),
                      for (final perm in byRole[role]!)
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(_permissionLabel(perm.permission)),
                          value: perm.allowed,
                          onChanged: role == AppRole.admin
                              ? null
                              : (v) async {
                                  await ref.read(rolePermissionRepositoryProvider).setAllowed(role: role, permission: perm.permission, allowed: v);
                                  ref.invalidate(adminPermissionsProvider);
                                },
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load permissions'),
      ),
    );
  }

  String _permissionLabel(String key) {
    return key.replaceAll('.', ' → ').replaceAll('_', ' ');
  }
}
