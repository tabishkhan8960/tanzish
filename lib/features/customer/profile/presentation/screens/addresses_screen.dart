import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/repositories/address_repository.dart';
import '../../../../../shared/widgets/address_form_sheet.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../../checkout/presentation/providers/checkout_providers.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      floatingActionButton: userId == null
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await showAddressFormSheet(context, ref, userId: userId);
                ref.invalidate(addressesProvider);
              },
              child: const Icon(Icons.add),
            ),
      body: addressesAsync.when(
        data: (addresses) => addresses.isEmpty
            ? const EmptyView(message: 'No addresses saved yet', icon: Icons.location_on_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: addresses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final a = addresses[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(a.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if (a.isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                      child: const Text('Default', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(a.formatted, style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (v) async {
                            if (v == 'default') {
                              await ref.read(addressRepositoryProvider).setDefault(userId!, a.id);
                            } else if (v == 'delete') {
                              await ref.read(addressRepositoryProvider).delete(a.id);
                            }
                            ref.invalidate(addressesProvider);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'default', child: Text('Set as default')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load addresses'),
      ),
    );
  }
}
