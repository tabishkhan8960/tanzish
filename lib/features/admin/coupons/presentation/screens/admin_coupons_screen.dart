import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/coupon.dart';
import '../../../../../shared/repositories/coupon_repository.dart';
import '../providers/admin_coupons_providers.dart';

class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(adminCouponsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupon Code'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => showDialog(context: context, builder: (_) => const _CouponFormDialog())),
        ],
      ),
      body: couponsAsync.when(
        data: (coupons) => coupons.isEmpty
            ? const EmptyView(message: 'No coupons yet', icon: Icons.confirmation_number_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: coupons.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final c = coupons[i];
                  final discount = c.discountType == DiscountType.percentage ? '${c.discountValue.toStringAsFixed(0)}%' : formatCurrency(c.discountValue);
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('$discount off · min ${formatCurrency(c.minOrderAmount)} · used ${c.usedCount}${c.usageLimit != null ? '/${c.usageLimit}' : ''}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Switch(
                          value: c.isActive,
                          onChanged: (v) async {
                            await ref.read(couponRepositoryProvider).setActive(c.id, v);
                            ref.invalidate(adminCouponsProvider);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () async {
                            await ref.read(couponRepositoryProvider).delete(c.id);
                            ref.invalidate(adminCouponsProvider);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load coupons'),
      ),
    );
  }
}

class _CouponFormDialog extends ConsumerStatefulWidget {
  const _CouponFormDialog();

  @override
  ConsumerState<_CouponFormDialog> createState() => _CouponFormDialogState();
}

class _CouponFormDialogState extends ConsumerState<_CouponFormDialog> {
  final _code = TextEditingController();
  final _value = TextEditingController();
  final _minOrder = TextEditingController(text: '0');
  DiscountType _type = DiscountType.percentage;
  bool _saving = false;

  @override
  void dispose() {
    _code.dispose();
    _value.dispose();
    _minOrder.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_code.text.trim().isEmpty || _value.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(couponRepositoryProvider).upsert({
        'code': _code.text.trim().toUpperCase(),
        'discount_type': _type.name,
        'discount_value': num.tryParse(_value.text) ?? 0,
        'min_order_amount': num.tryParse(_minOrder.text) ?? 0,
      });
      ref.invalidate(adminCouponsProvider);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Coupon'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: _code, hint: 'Coupon code (e.g. SAVE20)'),
            const SizedBox(height: 12),
            SegmentedButton<DiscountType>(
              segments: const [
                ButtonSegment(value: DiscountType.percentage, label: Text('Percentage')),
                ButtonSegment(value: DiscountType.fixed, label: Text('Fixed')),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() => _type = v.first),
            ),
            const SizedBox(height: 12),
            AppTextField(controller: _value, hint: 'Discount value', keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            AppTextField(controller: _minOrder, hint: 'Minimum order amount', keyboardType: TextInputType.number),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        PrimaryButton(label: 'Save', onPressed: _save, loading: _saving),
      ],
    );
  }
}
