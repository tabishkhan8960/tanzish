import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/category.dart';
import '../providers/admin_categories_providers.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(adminCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => showDialog(context: context, builder: (_) => const _CategoryFormDialog()))],
      ),
      body: categoriesAsync.when(
        data: (categories) => categories.isEmpty
            ? const EmptyView(message: 'No categories yet', icon: Icons.category_outlined)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final c = categories[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: AppColors.background, backgroundImage: c.imageUrl != null ? NetworkImage(c.imageUrl!) : null, child: c.imageUrl == null ? const Icon(Icons.category_outlined, color: AppColors.textSecondary) : null),
                    title: Text(c.name),
                    subtitle: Text(c.slug, style: const TextStyle(color: AppColors.textSecondary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(value: c.isActive, onChanged: (v) async {
                          await AdminCategoryActions.setActive(c.id, v);
                          ref.invalidate(adminCategoriesProvider);
                        }),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => showDialog(context: context, builder: (_) => _CategoryFormDialog(category: c)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          onPressed: () async {
                            await AdminCategoryActions.delete(c.id);
                            ref.invalidate(adminCategoriesProvider);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load categories'),
      ),
    );
  }
}

class _CategoryFormDialog extends ConsumerStatefulWidget {
  const _CategoryFormDialog({this.category});
  final Category? category;

  @override
  ConsumerState<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends ConsumerState<_CategoryFormDialog> {
  late final _name = TextEditingController(text: widget.category?.name);
  late final _imageUrl = TextEditingController(text: widget.category?.imageUrl);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final slug = _name.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      await AdminCategoryActions.upsert({
        'name': _name.text.trim(),
        'slug': slug,
        'image_url': _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
      }, id: widget.category?.id);
      ref.invalidate(adminCategoriesProvider);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'New Category' : 'Edit Category'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: _name, hint: 'Category name'),
            const SizedBox(height: 12),
            AppTextField(controller: _imageUrl, hint: 'Image URL (optional)'),
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
