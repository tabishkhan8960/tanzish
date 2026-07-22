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
  final _utrController = TextEditingController();
  String _paymentMethod = 'cod';
  bool _placing = false;
  String? _couponError;

  @override
  void dispose() {
    _couponController.dispose();
    _utrController.dispose();
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
    final addressId = ref.read(selectedAddressIdProvider) ?? ref.read(addressesProvider).value?.firstOrNull?.id;
    final methods = ref.read(shippingMethodsProvider).value ?? const [];
    final shippingMethodId = ref.read(selectedShippingMethodIdProvider) ?? methods.firstOrNull?.id;
    final items = ref.read(cartControllerProvider).value ?? [];
    final coupon = ref.read(appliedCouponProvider);

    if (addressId == null || shippingMethodId == null || items.isEmpty) return;

    if (_paymentMethod == 'upi' && _utrController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter the UTR / Transaction ID from your UPI app')));
      return;
    }

    setState(() => _placing = true);
    try {
      final order = await ref.read(orderRepositoryProvider).placeOrder(
            shippingAddressId: addressId,
            shippingMethodId: shippingMethodId,
            couponCode: coupon?.code,
            paymentProvider: _paymentMethod,
            paymentTransactionRef: _paymentMethod == 'upi' ? _utrController.text.trim() : null,
          );
      ref.invalidate(cartControllerProvider);
      if (mounted) context.go('/checkout/success/${order.id}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_friendlyError(e))));
      }
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  String _friendlyError(Object e) {
    // Postgres RPC exceptions arrive as "PostgrestException(message: <our
    // raise exception text>, ...)" — surface just the message we wrote in
    // the function rather than the wrapper noise.
    final text = e.toString();
    final match = RegExp(r'message:\s*([^,]+)').firstMatch(text);
    return match?.group(1)?.trim() ?? 'Could not place order. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final addressesAsync = ref.watch(addressesProvider);
    final selectedAddressId = ref.watch(selectedAddressIdProvider);
    final methodsAsync = ref.watch(shippingMethodsProvider);
    final selectedMethodId = ref.watch(selectedShippingMethodIdProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final coupon = ref.watch(appliedCouponProvider);
    final discount = coupon?.discountFor(subtotal) ?? 0;
    final methods = methodsAsync.value ?? const [];
    final shippingFee = methods.isEmpty
        ? 0
        : methods.firstWhere((m) => m.id == (selectedMethodId ?? methods.first.id), orElse: () => methods.first).price;
    final total = subtotal + shippingFee - discount;
    final userId = ref.watch(currentUserIdProvider);
    final canPlaceOrder = selectedAddressId != null || (addressesAsync.value?.isNotEmpty ?? false);

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
          const Text('Delivery Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          methodsAsync.when(
            data: (methods) => methods.isEmpty
                ? const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('No delivery methods configured.', style: TextStyle(color: AppColors.textSecondary)))
                : Column(
                    children: [
                      for (final m in methods)
                        RadioListTile<String>(
                          value: m.id,
                          groupValue: selectedMethodId ?? methods.first.id,
                          onChanged: (v) => ref.read(selectedShippingMethodIdProvider.notifier).state = v,
                          title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${m.description ?? ''} · ${m.etaLabel}'.trim()),
                          secondary: Text(m.price == 0 ? 'Free' : formatCurrency(m.price), style: const TextStyle(fontWeight: FontWeight.w600)),
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
                  ),
            loading: () => const Padding(padding: EdgeInsets.all(16), child: LoadingView()),
            error: (e, _) => const ErrorView(message: 'Could not load delivery methods'),
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
              ChoiceChip(
                label: const Text('Cash on Delivery'),
                selected: _paymentMethod == 'cod',
                onSelected: (_) => setState(() => _paymentMethod = 'cod'),
              ),
              ChoiceChip(
                label: const Text('UPI'),
                selected: _paymentMethod == 'upi',
                onSelected: (_) => setState(() => _paymentMethod = 'upi'),
              ),
            ],
          ),
          if (_paymentMethod == 'upi') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('UPI ID', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, letterSpacing: .5)),
                  const SizedBox(height: 4),
                  ref.watch(upiCollectionIdProvider).when(
                        data: (upiId) => Text(upiId ?? 'Not configured', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        loading: () => const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                        error: (e, _) => const Text('Could not load UPI ID', style: TextStyle(color: AppColors.error)),
                      ),
                  const SizedBox(height: 12),
                  Text(
                    'Open GPay, PhonePe or any UPI app → send ${formatCurrency(total)} to the UPI ID above → open transaction history → copy the UTR / Transaction ID',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _utrController,
                    decoration: const InputDecoration(labelText: 'UTR / Transaction ID', border: OutlineInputBorder(), isDense: true),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your order will be confirmed once we verify the payment — usually within a few hours.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _summaryRow('Order', formatCurrency(subtotal)),
                _summaryRow('Shipping', shippingFee == 0 ? 'Free' : formatCurrency(shippingFee)),
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
            label: _paymentMethod == 'upi' ? 'Place Order' : 'Place Order (Cash on Delivery)',
            loading: _placing,
            onPressed: !canPlaceOrder ? null : _placeOrder,
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
