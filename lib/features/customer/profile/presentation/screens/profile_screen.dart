import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../auth/data/auth_repository.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: profileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 32, backgroundColor: AppColors.background, child: Icon(Icons.person, size: 32, color: AppColors.textSecondary)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile?.fullName ?? 'Your Name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(profile?.phone ?? '', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _MenuTile(icon: Icons.receipt_long_outlined, label: 'My Orders', onTap: () => context.push('/orders')),
            _MenuTile(icon: Icons.favorite_border, label: 'Wishlist', onTap: () => context.push('/wishlist')),
            _MenuTile(icon: Icons.location_on_outlined, label: 'My Addresses', onTap: () => context.push('/addresses')),
            _MenuTile(icon: Icons.notifications_none_rounded, label: 'Notifications', onTap: () => context.push('/notifications')),
            const SizedBox(height: 12),
            _MenuTile(
              icon: Icons.logout,
              label: 'Sign Out',
              color: AppColors.error,
              onTap: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Could not load profile')),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.color});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(label, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
