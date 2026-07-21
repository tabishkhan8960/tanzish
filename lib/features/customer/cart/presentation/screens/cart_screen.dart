import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/cart_item.dart';
import '../providers/cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartControllerProvider);
    final subtotal = ref.watch(cartSubtotalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Bag')),
      body: cartAsync.when(
        data: (items) => items.isEmpty
            ? const EmptyView(message: 'Your cart is empty', icon: Icons.shopping_cart_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _CartTile(item: items[i]),
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load your cart'),
      ),
      bottomNavigationBar: cartAsync.maybeWhen(
        data: (items) => items.isEmpty
            ? null
            : SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: TextStyle(color: AppColors.textSecondary)),
                          Text(formatCurrency(subtotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(label: 'Checkout', onPressed: () => context.push('/checkout')),
                    ],
                  ),
                ),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _CartTile extends ConsumerWidget {
  const _CartTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 72,
              height: 72,
              child: product?.primaryImageUrl != null
                  ? CachedNetworkImage(imageUrl: product!.primaryImageUrl!, fit: BoxFit.cover)
                  : Container(color: AppColors.background, child: const Icon(Icons.image_outlined, color: AppColors.textSecondary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product?.name ?? 'Product', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                if (item.variantAttributes.isNotEmpty)
                  Text(
                    item.variantAttributes.entries.map((e) => '${e.key}: ${e.value}').join(', '),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                const SizedBox(height: 6),
                Text(formatCurrency(product?.price ?? 0), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textSecondary),
                onPressed: () => ref.read(cartControllerProvider.notifier).remove(item.id),
              ),
              Row(
                children: [
                  _StepperButton(icon: Icons.remove, onTap: () => ref.read(cartControllerProvider.notifier).updateQuantity(item.id, item.quantity - 1)),
                  SizedBox(width: 28, child: Center(child: Text('${item.quantity}'))),
                  _StepperButton(icon: Icons.add, onTap: () => ref.read(cartControllerProvider.notifier).updateQuantity(item.id, item.quantity + 1)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 14),
      ),
    );
  }
}
