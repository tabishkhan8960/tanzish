import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/profile.dart';
import '../../../../../shared/repositories/customer_repository.dart';

final adminStaffProvider = FutureProvider<List<Profile>>((ref) {
  return ref.watch(customerRepositoryProvider).fetchStaff();
});

class AdminRolesScreen extends ConsumerWidget {
  const AdminRolesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(adminStaffProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin role')),
      body: staffAsync.when(
        data: (staff) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Staff & admin accounts. Promote a customer to a role by entering their user id — new signups default to Customer.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            Expanded(
              child: staff.isEmpty
                  ? const EmptyView(message: 'No staff accounts yet', icon: Icons.admin_panel_settings_outlined)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: staff.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final s = staff[i];
                        return ListTile(
                          leading: const CircleAvatar(backgroundColor: AppColors.background, child: Icon(Icons.person, color: AppColors.textSecondary)),
                          title: Text(s.fullName ?? s.id),
                          subtitle: Text(s.role.label),
                          trailing: DropdownButton<AppRole>(
                            value: s.role,
                            items: [for (final r in AppRole.values) DropdownMenuItem(value: r, child: Text(r.label))],
                            onChanged: (role) async {
                              if (role == null) return;
                              await ref.read(customerRepositoryProvider).setRole(s.id, role);
                              ref.invalidate(adminStaffProvider);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load staff accounts'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Promote user'),
        onPressed: () => showDialog(context: context, builder: (_) => const _PromoteUserDialog()),
      ),
    );
  }
}

class _PromoteUserDialog extends ConsumerStatefulWidget {
  const _PromoteUserDialog();

  @override
  ConsumerState<_PromoteUserDialog> createState() => _PromoteUserDialogState();
}

class _PromoteUserDialogState extends ConsumerState<_PromoteUserDialog> {
  final _userId = TextEditingController();
  AppRole _role = AppRole.storeManager;
  bool _saving = false;

  @override
  void dispose() {
    _userId.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_userId.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(customerRepositoryProvider).setRole(_userId.text.trim(), _role);
      ref.invalidate(adminStaffProvider);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Promote user'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _userId, decoration: const InputDecoration(labelText: 'User ID (from profiles.id)')),
            const SizedBox(height: 12),
            DropdownButtonFormField<AppRole>(
              initialValue: _role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: [for (final r in AppRole.values.where((r) => r != AppRole.customer)) DropdownMenuItem(value: r, child: Text(r.label))],
              onChanged: (v) => setState(() => _role = v ?? _role),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _saving ? null : _save, child: _saving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save')),
      ],
    );
  }
}
