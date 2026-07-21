import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/product.dart';
import '../../../../customer/home/presentation/providers/home_providers.dart';
import '../providers/admin_products_providers.dart';

class AdminAddProductScreen extends ConsumerStatefulWidget {
  const AdminAddProductScreen({super.key, this.productId});

  final String? productId;

  @override
  ConsumerState<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends ConsumerState<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _comparePrice = TextEditingController();
  final _sku = TextEditingController();
  final _imageUrls = TextEditingController();
  String? _categoryId;
  String? _brandId;
  bool _isFeatured = false;
  bool _saving = false;
  bool _hydrated = false;

  bool get _isEdit => widget.productId != null;

  void _hydrate(Product product) {
    if (_hydrated) return;
    _hydrated = true;
    _name.text = product.name;
    _description.text = product.description ?? '';
    _price.text = product.price.toString();
    _comparePrice.text = product.compareAtPrice?.toString() ?? '';
    _sku.text = product.sku ?? '';
    _imageUrls.text = product.images.map((i) => i.imageUrl).join(', ');
    _categoryId = product.categoryId;
    _brandId = product.brandId;
    _isFeatured = product.isFeatured;
  }

  @override
  void dispose() {
    for (final c in [_name, _description, _price, _comparePrice, _sku, _imageUrls]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final slug = _name.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      final id = await AdminProductActions.upsert({
        'name': _name.text.trim(),
        'slug': slug,
        'description': _description.text.trim().isEmpty ? null : _description.text.trim(),
        'price': num.tryParse(_price.text) ?? 0,
        'compare_at_price': _comparePrice.text.trim().isEmpty ? null : num.tryParse(_comparePrice.text),
        'sku': _sku.text.trim().isEmpty ? null : _sku.text.trim(),
        'category_id': _categoryId,
        'brand_id': _brandId,
        'is_featured': _isFeatured,
      }, id: widget.productId);

      final urls = _imageUrls.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      await AdminProductActions.replaceImages(id, urls);

      ref.invalidate(adminProductsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEdit ? 'Product updated' : 'Product created')));
        context.go('/admin/products');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(adminAllCategoriesProvider);
    final brandsAsync = ref.watch(adminAllBrandsProvider);
    final productAsync = _isEdit ? ref.watch(productProvider(widget.productId!)) : null;

    Widget form() {
      return Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(controller: _name, hint: 'Product name', label: 'Name', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 14),
              AppTextField(controller: _description, hint: 'Product description', label: 'Description'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: AppTextField(controller: _price, hint: '0.00', label: 'Price', keyboardType: TextInputType.number, validator: (v) => num.tryParse(v ?? '') == null ? 'Enter a valid price' : null)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(controller: _comparePrice, hint: 'Optional', label: 'Compare-at price', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 14),
              AppTextField(controller: _sku, hint: 'SKU (optional)', label: 'SKU'),
              const SizedBox(height: 14),
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [for (final c in categories) DropdownMenuItem(value: c.id, child: Text(c.name))],
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
                loading: () => const LoadingView(),
                error: (e, _) => const Text('Could not load categories'),
              ),
              const SizedBox(height: 14),
              brandsAsync.when(
                data: (brands) => DropdownButtonFormField<String>(
                  initialValue: _brandId,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  items: [for (final b in brands) DropdownMenuItem(value: b.id, child: Text(b.name))],
                  onChanged: (v) => setState(() => _brandId = v),
                ),
                loading: () => const LoadingView(),
                error: (e, _) => const Text('Could not load brands'),
              ),
              const SizedBox(height: 14),
              AppTextField(controller: _imageUrls, hint: 'https://…, https://…', label: 'Image URLs (comma-separated)'),
              const SizedBox(height: 10),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Featured product'),
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: _isEdit ? 'Save Changes' : 'Add Product', onPressed: _save, loading: _saving),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Product' : 'Add Products')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isEdit
            ? productAsync!.when(
                data: (product) {
                  _hydrate(product);
                  return SingleChildScrollView(child: form());
                },
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Could not load product'),
              )
            : SingleChildScrollView(child: form()),
      ),
    );
  }
}
