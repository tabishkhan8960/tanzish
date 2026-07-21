import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/models/inventory.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../core/config/supabase_config.dart';
import '../../../../../core/constants/supabase_tables.dart';
import '../../../../../shared/widgets/product_image_manager.dart';
import '../../../../../shared/widgets/product_image_upload_field.dart';
import '../../domain/category_schema.dart';
import '../providers/admin_products_providers.dart';
import '../widgets/admin_variant_manager.dart';

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
  final _imageManager = ProductImageManager();
  
  String? _categoryId;
  String? _brandId;
  bool _isActive = true;
  bool _isFeatured = false;
  bool _saving = false;
  bool _hydrated = false;
  
  // Dynamic fields mapped by name -> controller
  final Map<String, TextEditingController> _dynamicControllers = {};
  
  // Variants
  List<Inventory> _variants = [];
  bool _variantsLoading = false;

  bool get _isEdit => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadVariants();
    } else {
      _variants = [Inventory(id: '', productId: '', updatedAt: DateTime.now(), variantAttributes: {})]; // Default no-variant
    }
  }

  Future<void> _loadVariants() async {
    setState(() => _variantsLoading = true);
    try {
      final rows = await SupabaseConfig.client.from(SupabaseTables.inventory).select().eq('product_id', widget.productId!);
      setState(() {
        _variants = rows.map((e) => Inventory.fromJson(e)).toList();
        if (_variants.isEmpty) {
          _variants = [Inventory(id: '', productId: widget.productId!, updatedAt: DateTime.now(), variantAttributes: {})];
        }
      });
    } catch (e) {
      // Ignored for now
    } finally {
      setState(() => _variantsLoading = false);
    }
  }

  void _hydrate(Product product, List<CategoryField> fields) {
    if (_hydrated) return;
    _hydrated = true;
    _name.text = product.name;
    _description.text = product.description ?? '';
    _imageManager.loadExisting(product.images.map((i) => i.imageUrl).toList());
    _categoryId = product.categoryId;
    _brandId = product.brandId;
    _isActive = product.isActive;
    _isFeatured = product.isFeatured;
    
    // Hydrate dynamic fields
    for (final field in fields) {
      final val = product.attributes[field.name];
      if (val != null) {
        if (!_dynamicControllers.containsKey(field.name)) {
          _dynamicControllers[field.name] = TextEditingController();
        }
        _dynamicControllers[field.name]!.text = val.toString();
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _imageManager.dispose();
    for (final c in _dynamicControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCategoryChanged(String? newCategoryId, String categoryName) {
    setState(() {
      _categoryId = newCategoryId;
      // Re-initialize dynamic controllers for the new category
      final fields = CategorySchema.getFieldsForCategory(categoryName);
      _dynamicControllers.clear();
      for (final f in fields) {
        _dynamicControllers[f.name] = TextEditingController();
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('At least one variant must exist.')));
      return;
    }
    
    setState(() => _saving = true);
    try {
      final urls = await _imageManager.uploadPendingAndGetOrderedUrls();
      final slug = _name.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      
      // Collect dynamic attributes
      final Map<String, dynamic> attributes = {};
      _dynamicControllers.forEach((k, v) {
        if (v.text.trim().isNotEmpty) {
          attributes[k] = v.text.trim();
        }
      });

      // The base product price takes from the first variant
      final basePrice = _variants.first.price ?? 0;
      final baseComparePrice = _variants.first.compareAtPrice;
      final baseSku = _variants.first.sku;
      final baseBarcode = _variants.first.barcode;
      final baseWeight = _variants.first.weightGrams;

      final id = await AdminProductActions.upsert({
        'name': _name.text.trim(),
        'slug': slug,
        'description': _description.text.trim().isEmpty ? null : _description.text.trim(),
        'price': basePrice,
        'compare_at_price': baseComparePrice,
        'sku': baseSku,
        'barcode': baseBarcode,
        'weight_grams': baseWeight,
        'category_id': _categoryId,
        'brand_id': _brandId,
        'is_active': _isActive,
        'is_featured': _isFeatured,
        'attributes': attributes,
      }, id: widget.productId);

      await AdminProductActions.replaceImages(id, urls);
      await AdminProductActions.upsertVariants(id, _variants);

      ref.invalidate(adminProductsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEdit ? 'Product updated' : 'Product created')));
        context.go('/admin/products');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
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

    Widget form(List<CategoryField> fields) {
      return Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(controller: _name, hint: 'Product name', label: 'Name', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 14),
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [for (final c in categories) DropdownMenuItem(value: c.id, child: Text(c.name))],
                  onChanged: (v) {
                    final catName = categories.firstWhere((c) => c.id == v).name;
                    _onCategoryChanged(v, catName);
                  },
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
              const SizedBox(height: 20),
              if (fields.isNotEmpty) ...[
                const Text('Category Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: fields.map((f) {
                    if (!_dynamicControllers.containsKey(f.name)) {
                      _dynamicControllers[f.name] = TextEditingController();
                    }
                    if (f.type == CategoryFieldType.dropdown) {
                      return SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          initialValue: _dynamicControllers[f.name]!.text.isEmpty ? null : _dynamicControllers[f.name]!.text,
                          decoration: InputDecoration(labelText: f.label),
                          items: f.options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                          onChanged: (v) => setState(() => _dynamicControllers[f.name]!.text = v ?? ''),
                          validator: f.isRequired ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
                        ),
                      );
                    }
                    return SizedBox(
                      width: 300,
                      child: AppTextField(
                        controller: _dynamicControllers[f.name]!,
                        hint: '',
                        label: f.label,
                        validator: f.isRequired ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
                        keyboardType: f.type == CategoryFieldType.number ? TextInputType.number : TextInputType.text,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
              AppTextField(controller: _description, hint: 'Product description', label: 'Description'),
              const SizedBox(height: 14),
              ProductImageUploadField(manager: _imageManager),
              const SizedBox(height: 20),
              if (_variantsLoading) const LoadingView() else AdminVariantManager(
                variants: _variants,
                onChanged: (v) => setState(() => _variants = v),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Status: Active'),
                subtitle: const Text('Product will be hidden from customers if disabled.'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
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
                  return categoriesAsync.when(
                    data: (categories) {
                      final cName = categories.firstWhere((c) => c.id == product.categoryId, orElse: () => categories.first).name;
                      final fields = CategorySchema.getFieldsForCategory(cName);
                      _hydrate(product, fields);
                      return SingleChildScrollView(child: form(fields));
                    },
                    loading: () => const LoadingView(),
                    error: (e, _) => const ErrorView(message: 'Could not load categories'),
                  );
                },
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Could not load product'),
              )
            : categoriesAsync.when(
                data: (categories) {
                  final catName = _categoryId != null ? categories.firstWhere((c) => c.id == _categoryId, orElse: () => categories.first).name : '';
                  final fields = CategorySchema.getFieldsForCategory(catName);
                  return SingleChildScrollView(child: form(fields));
                },
                loading: () => const LoadingView(),
                error: (e, _) => const ErrorView(message: 'Could not load categories'),
              ),
      ),
    );
  }
}
