import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/order_status_badge.dart';
import '../providers/orders_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ordersAsync.when(
        data: (orders) => orders.isEmpty
            ? const EmptyView(message: 'No orders yet', icon: Icons.receipt_long_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final order = orders[i];
                  return ListTile(
                    tileColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    title: Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${formatDate(order.placedAt)} · ${order.items.length} item(s)'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formatCurrency(order.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        OrderStatusBadge(status: order.status),
                      ],
                    ),
                    onTap: () => context.push('/orders/${order.id}'),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load orders'),
      ),
    );
  }
}
