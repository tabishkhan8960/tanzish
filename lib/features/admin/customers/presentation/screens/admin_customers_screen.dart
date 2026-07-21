import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/profile.dart';
import '../../../../../shared/widgets/order_status_badge.dart';
import '../providers/admin_customers_providers.dart';

class AdminCustomersScreen extends ConsumerWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(adminCustomersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search customers by name'),
              onChanged: (v) => ref.read(customersSearchProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: customersAsync.when(
              data: (customers) => customers.isEmpty
                  ? const EmptyView(message: 'No customers yet', icon: Icons.people_outline)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: customers.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final c = customers[i];
                        return ListTile(
                          leading: const CircleAvatar(backgroundColor: AppColors.background, child: Icon(Icons.person, color: AppColors.textSecondary)),
                          title: Text(c.fullName ?? 'Unnamed customer'),
                          subtitle: Text(c.phone ?? ''),
                          onTap: () => showDialog(context: context, builder: (_) => _CustomerDetailDialog(customer: c)),
                        );
                      },
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => const ErrorView(message: 'Could not load customers'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerDetailDialog extends ConsumerWidget {
  const _CustomerDetailDialog({required this.customer});
  final Profile customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider(customer.id));

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(customer.fullName ?? 'Unnamed customer', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(customer.phone ?? '', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              const Text('Order overview', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ordersAsync.when(
                  data: (orders) => orders.isEmpty
                      ? const Text('No orders yet', style: TextStyle(color: AppColors.textSecondary))
                      : ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, i) {
                            final o = orders[i];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(o.orderNumber),
                              subtitle: Text(formatDate(o.placedAt)),
                              trailing: OrderStatusBadge(status: o.status),
                            );
                          },
                        ),
                  loading: () => const LoadingView(),
                  error: (e, _) => const Text('Could not load orders'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
