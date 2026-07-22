import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/payment.dart';
import '../../../orders/presentation/providers/orders_providers.dart';

class OrderSuccessScreen extends ConsumerWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      body: SafeArea(
        child: orderAsync.when(
          data: (order) {
            final payment = order.payments.firstOrNull;
            final isUpiPending = payment?.provider == 'upi' && payment?.status == PaymentStatus.pending;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(color: isUpiPending ? AppColors.warning : AppColors.success, shape: BoxShape.circle),
                    child: Icon(isUpiPending ? Icons.hourglass_top : Icons.check, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isUpiPending ? 'Order placed — verifying payment' : 'Order placed successfully',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.orderNumber,
                    style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUpiPending
                        ? "We'll confirm your order as soon as we verify your UPI payment."
                        : payment?.provider == 'cod'
                            ? 'Pay ${formatCurrency(order.total)} in cash when your order arrives.'
                            : 'Your order is being prepared.',
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _row('Amount', formatCurrency(order.total)),
                        _row('Payment', payment == null ? '—' : '${payment.provider.toUpperCase()} · ${paymentStatusLabel(payment.status)}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(label: 'Track Order', onPressed: () => context.go('/orders/${order.id}')),
                  const SizedBox(height: 12),
                  PrimaryButton(label: 'Continue Shopping', outlined: true, onPressed: () => context.go('/home')),
                ],
              ),
            );
          },
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: 'Could not load your order',
            onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: const TextStyle(color: AppColors.textSecondary)), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))],
      ),
    );
  }
}
