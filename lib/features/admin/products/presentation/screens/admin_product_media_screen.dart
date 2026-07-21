import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/product.dart';
import '../providers/admin_products_providers.dart';

class AdminProductMediaScreen extends ConsumerWidget {
  const AdminProductMediaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Media')),
      body: productsAsync.when(
        data: (products) => products.isEmpty
            ? const EmptyView(message: 'No products yet', icon: Icons.perm_media_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final p = products[i];
                  return ListTile(
                    leading: SizedBox(
                      width: 44,
                      height: 44,
                      child: p.primaryImageUrl != null
                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: CachedNetworkImage(imageUrl: p.primaryImageUrl!, fit: BoxFit.cover))
                          : Container(decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.image_outlined, color: AppColors.textSecondary)),
                    ),
                    title: Text(p.name),
                    subtitle: Text('${p.images.length} image(s)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showDialog(context: context, builder: (_) => _ProductMediaDialog(product: p)),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load products'),
      ),
    );
  }
}

class _ProductMediaDialog extends ConsumerStatefulWidget {
  const _ProductMediaDialog({required this.product});
  final Product product;

  @override
  ConsumerState<_ProductMediaDialog> createState() => _ProductMediaDialogState();
}

class _ProductMediaDialogState extends ConsumerState<_ProductMediaDialog> {
  late final _controller = TextEditingController(text: widget.product.images.map((i) => i.imageUrl).join(', '));
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final urls = _controller.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      await AdminProductActions.replaceImages(widget.product.id, urls);
      ref.invalidate(adminProductsProvider);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product.name),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Image URLs, comma-separated. First one is the primary image.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 10),
            AppTextField(controller: _controller, hint: 'https://…, https://…'),
            if (widget.product.images.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final img in widget.product.images)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(imageUrl: img.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                ],
              ),
            ],
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
