import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/order.dart';
import '../../../../../shared/widgets/order_status_badge.dart';
import '../providers/admin_orders_providers.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);
    final filter = ref.watch(adminOrderStatusFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Management')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(label: const Text('All'), selected: filter == null, onSelected: (_) => ref.read(adminOrderStatusFilterProvider.notifier).state = null),
                for (final status in OrderStatus.values)
                  ChoiceChip(
                    label: Text(statusLabel(status)),
                    selected: filter == status,
                    onSelected: (_) => ref.read(adminOrderStatusFilterProvider.notifier).state = status,
                  ),
              ],
            ),
          ),
          Expanded(
            child: ordersAsync.when(
              data: (orders) => orders.isEmpty
                  ? const EmptyView(message: 'No orders found', icon: Icons.receipt_long_outlined)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Order ID')),
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Items')),
                          DataColumn(label: Text('Total')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: [
                          for (final order in orders)
                            DataRow(
                              onSelectChanged: (_) => context.push('/admin/orders/${order.id}'),
                              cells: [
                                DataCell(Text(order.orderNumber)),
                                DataCell(Text(order.shippingAddress?.fullName ?? '—')),
                                DataCell(Text(formatDate(order.placedAt))),
                                DataCell(Text('${order.items.length}')),
                                DataCell(Text(formatCurrency(order.total))),
                                DataCell(OrderStatusBadge(status: order.status)),
                              ],
                            ),
                        ],
                      ),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => const ErrorView(message: 'Could not load orders'),
            ),
          ),
        ],
      ),
    );
  }
}
