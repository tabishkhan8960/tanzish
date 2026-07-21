import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/repositories/coupon_repository.dart';
import '../../../../../shared/repositories/order_repository.dart';
import '../../../../../shared/widgets/address_form_sheet.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../providers/checkout_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _couponController = TextEditingController();
  String _paymentMethod = 'Visa';
  bool _placing = false;
  String? _couponError;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    setState(() => _couponError = null);
    final coupon = await ref.read(couponRepositoryProvider).findByCode(code);
    if (coupon == null || !coupon.isActive) {
      setState(() => _couponError = 'Invalid or expired coupon');
      return;
    }
    ref.read(appliedCouponProvider.notifier).state = coupon;
  }

  Future<void> _placeOrder() async {
    final userId = ref.read(currentUserIdProvider);
    final addressId = ref.read(selectedAddressIdProvider);
    final items = ref.read(cartControllerProvider).value ?? [];
    if (userId == null || addressId == null || items.isEmpty) return;

    setState(() => _placing = true);
    try {
      final subtotal = ref.read(cartSubtotalProvider);
      final coupon = ref.read(appliedCouponProvider);
      final discount = coupon?.discountFor(subtotal) ?? 0;

      final order = await ref.read(orderRepositoryProvider).placeOrder(
            userId: userId,
            items: items,
            shippingAddressId: addressId,
            subtotal: subtotal,
            shippingFee: shippingFee,
            discount: discount,
            couponId: coupon?.id,
          );
      await ref.read(orderRepositoryProvider).recordPayment(orderId: order.id, provider: _paymentMethod, amount: order.total);
      ref.invalidate(cartControllerProvider);
      if (mounted) context.go('/checkout/success');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not place order. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressesAsync = ref.watch(addressesProvider);
    final selectedAddressId = ref.watch(selectedAddressIdProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final coupon = ref.watch(appliedCouponProvider);
    final discount = coupon?.discountFor(subtotal) ?? 0;
    final total = subtotal + shippingFee - discount;
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton.icon(
                onPressed: userId == null
                    ? null
                    : () async {
                        await showAddressFormSheet(context, ref, userId: userId);
                        ref.invalidate(addressesProvider);
                      },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          addressesAsync.when(
            data: (addresses) => addresses.isEmpty
                ? const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('No saved address yet — add one to continue.', style: TextStyle(color: AppColors.textSecondary)))
                : Column(
                    children: [
                      for (final a in addresses)
                        RadioListTile<String>(
                          value: a.id,
                          groupValue: selectedAddressId ?? addresses.first.id,
                          onChanged: (v) => ref.read(selectedAddressIdProvider.notifier).state = v,
                          title: Text(a.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(a.formatted),
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
                  ),
            loading: () => const Padding(padding: EdgeInsets.all(16), child: LoadingView()),
            error: (e, _) => const ErrorView(message: 'Could not load addresses'),
          ),
          const SizedBox(height: 12),
          const Text('Coupon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(hintText: 'Enter coupon code', errorText: _couponError),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _applyCoupon, child: const Text('Apply')),
            ],
          ),
          if (coupon != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Chip(
                label: Text('${coupon.code} applied — -${formatCurrency(discount)}'),
                onDeleted: () => ref.read(appliedCouponProvider.notifier).state = null,
              ),
            ),
          const SizedBox(height: 20),
          const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final method in ['Visa', 'PayPal', 'Mastercard', 'Cash on Delivery'])
                ChoiceChip(
                  label: Text(method),
                  selected: _paymentMethod == method,
                  onSelected: (_) => setState(() => _paymentMethod = method),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _summaryRow('Order', formatCurrency(subtotal)),
                _summaryRow('Shipping', formatCurrency(shippingFee)),
                if (discount > 0) _summaryRow('Discount', '-${formatCurrency(discount)}'),
                const Divider(),
                _summaryRow('Total', formatCurrency(total), bold: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            label: 'Proceed to Payment',
            loading: _placing,
            onPressed: (selectedAddressId == null && (addressesAsync.value?.isEmpty ?? true)) ? null : _placeOrder,
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 16 : 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style.copyWith(color: bold ? AppColors.textPrimary : AppColors.textSecondary)), Text(value, style: style)],
      ),
    );
  }
}
