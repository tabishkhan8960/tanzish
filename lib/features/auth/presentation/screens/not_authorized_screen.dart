import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/auth_repository.dart';

/// Shown when a signed-in account without the `admin` role lands here — this
/// app has no customer UI to send them to instead (that lives on `main`).
class NotAuthorizedScreen extends ConsumerWidget {
  const NotAuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                Text('Admin access required', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  "This account doesn't have admin access. Sign in with an admin account, or use the ShopHub customer app instead.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                PrimaryButton(label: 'Sign Out', onPressed: () => ref.read(authRepositoryProvider).signOut()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
