import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/state_views.dart';
import '../providers/notifications_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notificationsAsync.when(
        data: (items) => items.isEmpty
            ? const EmptyView(message: 'No notifications yet', icon: Icons.notifications_none_rounded)
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final n = items[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: n.isRead ? AppColors.background : AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.notifications, color: n.isRead ? AppColors.textSecondary : AppColors.primary, size: 18),
                    ),
                    title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
                    subtitle: n.body != null ? Text(n.body!) : null,
                    onTap: () async {
                      if (!n.isRead) {
                        await markNotificationRead(n.id);
                        ref.invalidate(notificationsProvider);
                      }
                    },
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load notifications'),
      ),
    );
  }
}
