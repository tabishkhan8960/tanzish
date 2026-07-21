import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/order_status_badge.dart';
import '../providers/orders_providers.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: orderAsync.when(
        data: (order) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.orderNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                OrderStatusBadge(status: order.status),
              ],
            ),
            Text('Placed on ${formatDate(order.placedAt)}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            if (order.shippingAddress != null) ...[
              const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(order.shippingAddress!.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
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
                    Expanded(
                      child: Text('${item.productName} × ${item.quantity}', overflow: TextOverflow.ellipsis),
                    ),
                    Text(formatCurrency(item.subtotal), style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            const Divider(height: 32),
            _row('Subtotal', formatCurrency(order.subtotal)),
            _row('Shipping', formatCurrency(order.shippingFee)),
            if (order.discount > 0) _row('Discount', '-${formatCurrency(order.discount)}'),
            const Divider(),
            _row('Total', formatCurrency(order.total), bold: true),
            if (order.payments.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${order.payments.first.provider} · ${order.payments.first.status.name}'),
            ],
          ],
        ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load order'),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: style), Text(value, style: style)]),
    );
  }
}
