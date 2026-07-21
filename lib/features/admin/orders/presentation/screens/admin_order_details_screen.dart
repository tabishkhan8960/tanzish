import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/order.dart';
import '../../../../../shared/repositories/order_repository.dart';
import '../../../../../shared/widgets/order_status_badge.dart';
import '../providers/admin_orders_providers.dart';

class AdminOrderDetailsScreen extends ConsumerWidget {
  const AdminOrderDetailsScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(adminOrderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: Text('Order ${orderId.substring(0, 8)}')),
      body: orderAsync.when(
        data: (order) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.orderNumber, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                DropdownButton<OrderStatus>(
                  value: order.status,
                  items: [for (final s in OrderStatus.values) DropdownMenuItem(value: s, child: Text(statusLabel(s)))],
                  onChanged: (status) async {
                    if (status == null) return;
                    await ref.read(orderRepositoryProvider).updateStatus(order.id, status);
                    ref.invalidate(adminOrderDetailProvider(orderId));
                    ref.invalidate(adminOrdersProvider);
                  },
                ),
              ],
            ),
            Text('Placed on ${formatDate(order.placedAt)}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            if (order.shippingAddress != null) ...[
              const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(order.shippingAddress!.fullName),
              Text(order.shippingAddress!.formatted, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),
            ],
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final item in order.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text('${item.productName} × ${item.quantity}')),
                    Text(formatCurrency(item.subtotal), style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            const Divider(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total'), Text(formatCurrency(order.total), style: const TextStyle(fontWeight: FontWeight.bold))]),
          ],
        ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load order'),
      ),
    );
  }
}
