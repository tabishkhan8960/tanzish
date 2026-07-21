import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/brand.dart';
import '../providers/admin_brands_providers.dart';

class AdminBrandsScreen extends ConsumerWidget {
  const AdminBrandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(adminBrandsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => showDialog(context: context, builder: (_) => const _BrandFormDialog()))],
      ),
      body: brandsAsync.when(
        data: (brands) => brands.isEmpty
            ? const EmptyView(message: 'No brands yet', icon: Icons.local_offer_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: brands.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final b = brands[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: AppColors.background, backgroundImage: b.logoUrl != null ? NetworkImage(b.logoUrl!) : null, child: b.logoUrl == null ? const Icon(Icons.local_offer_outlined, color: AppColors.textSecondary) : null),
                    title: Text(b.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(value: b.isActive, onChanged: (v) async {
                          await AdminBrandActions.setActive(b.id, v);
                          ref.invalidate(adminBrandsProvider);
                        }),
                        IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => showDialog(context: context, builder: (_) => _BrandFormDialog(brand: b))),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          onPressed: () async {
                            await AdminBrandActions.delete(b.id);
                            ref.invalidate(adminBrandsProvider);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load brands'),
      ),
    );
  }
}

class _BrandFormDialog extends ConsumerStatefulWidget {
  const _BrandFormDialog({this.brand});
  final Brand? brand;

  @override
  ConsumerState<_BrandFormDialog> createState() => _BrandFormDialogState();
}

class _BrandFormDialogState extends ConsumerState<_BrandFormDialog> {
  late final _name = TextEditingController(text: widget.brand?.name);
  late final _logoUrl = TextEditingController(text: widget.brand?.logoUrl);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _logoUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final slug = _name.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      await AdminBrandActions.upsert({
        'name': _name.text.trim(),
        'slug': slug,
        'logo_url': _logoUrl.text.trim().isEmpty ? null : _logoUrl.text.trim(),
      }, id: widget.brand?.id);
      ref.invalidate(adminBrandsProvider);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.brand == null ? 'New Brand' : 'Edit Brand'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: _name, hint: 'Brand name'),
            const SizedBox(height: 12),
            AppTextField(controller: _logoUrl, hint: 'Logo URL (optional)'),
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
