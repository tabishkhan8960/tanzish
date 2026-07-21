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
  
  ProductType? _productType;
  String? _categoryId;
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
    }
  }

  Future<void> _loadVariants() async {
    setState(() => _variantsLoading = true);
    try {
      final rows = await SupabaseConfig.client.from(SupabaseTables.inventory).select().eq('product_id', widget.productId!);
      setState(() {
        _variants = rows.map((e) => Inventory.fromJson(e)).toList();
      });
    } catch (e) {
      // Ignored for now
    } finally {
      setState(() => _variantsLoading = false);
    }
  }

  void _hydrate(Product product) {
    if (_hydrated) return;
    _hydrated = true;
    _name.text = product.name;
    _description.text = product.description ?? '';
    _categoryId = product.categoryId;
    _imageManager.loadExisting(product.images.map((i) => i.imageUrl).toList());
    
    // Parse the product type if saved in attributes
    if (product.attributes.containsKey('product_type')) {
      final savedType = product.attributes['product_type'] as String;
      _productType = ProductType.values.firstWhere((e) => e.name == savedType, orElse: () => ProductType.clothing);
    } else {
      _productType = ProductType.clothing;
    }
    
    _isActive = product.isActive;
    _isFeatured = product.isFeatured;
    
    // Hydrate dynamic fields
    final fields = CategorySchema.getFieldsForType(_productType!);
    for (final field in fields) {
      final val = product.attributes[field.name];
      if (val != null) {
        if (!_dynamicControllers.containsKey(field.name)) {
          _dynamicControllers[field.name] = TextEditingController();
        }
        _dynamicControllers[field.name]!.text = val.toString();
      }
    }

    if (_variants.isEmpty) {
       _variants = [Inventory(id: '', productId: widget.productId!, updatedAt: DateTime.now(), variantAttributes: {})];
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

  void _onProductTypeChanged(ProductType type) {
    setState(() {
      _productType = type;
      // Re-initialize dynamic controllers for the new product type
      final fields = CategorySchema.getFieldsForType(type);
      _dynamicControllers.clear();
      for (final f in fields) {
        _dynamicControllers[f.name] = TextEditingController();
      }
      // Reset variants entirely so schema matches the new type
      _variants = [Inventory(id: '', productId: '', updatedAt: DateTime.now(), variantAttributes: {})];
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_productType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a Product Type.')));
      return;
    }
    if (_variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('At least one variant must exist.')));
      return;
    }
    
    setState(() => _saving = true);
    try {
      final urls = await _imageManager.uploadPendingAndGetOrderedUrls();
      final slug = _name.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      
      // Collect dynamic attributes
      final Map<String, dynamic> attributes = {'product_type': _productType!.name};
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
    final productAsync = _isEdit ? ref.watch(productProvider(widget.productId!)) : null;

    Widget form() {
      final fields = _productType != null ? CategorySchema.getFieldsForType(_productType!) : <CategoryField>[];
      final variantColumns = _productType != null ? CategorySchema.getVariantColumnsForType(_productType!) : <String>[];

      return Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PRODUCT TYPE (Always visible first)
              const Text('Step 1: Select Product Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              DropdownButtonFormField<ProductType>(
                value: _productType,
                decoration: const InputDecoration(labelText: 'Product Type'),
                items: ProductType.values.map((pt) => DropdownMenuItem(value: pt, child: Text(CategorySchema.getLabelForType(pt)))).toList(),
                onChanged: (v) {
                  if (v != null) _onProductTypeChanged(v);
                },
                validator: (v) => v == null ? 'Please select a product type' : null,
              ),
              const SizedBox(height: 24),

              // 2. ONLY SHOW THE REST IF PRODUCT TYPE IS SELECTED
              if (_productType != null) ...[
                const Divider(),
                const SizedBox(height: 12),
                const Text('Step 2: General Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                AppTextField(controller: _name, hint: 'Product name', label: 'Name', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                const SizedBox(height: 14),
                ref.watch(adminAllCategoriesProvider).when(
                  data: (categories) => DropdownButtonFormField<String>(
                    value: _categoryId,
                    decoration: const InputDecoration(labelText: 'Store Menu Category (Appears in App Menu)'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('No menu category')),
                      for (final c in categories) DropdownMenuItem(value: c.id, child: Text(c.name))
                    ],
                    onChanged: (v) => setState(() => _categoryId = v),
                    validator: (v) => v == null ? 'Required for Customer App Menu' : null,
                  ),
                  loading: () => const LoadingView(),
                  error: (e, _) => const Text('Could not load categories'),
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
                      if (f.type == CategoryFieldType.boolean) {
                         return SizedBox(
                           width: 300,
                           child: SwitchListTile(
                             title: Text(f.label),
                             value: _dynamicControllers[f.name]!.text == 'true',
                             onChanged: (v) => setState(() => _dynamicControllers[f.name]!.text = v.toString()),
                           ),
                         );
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
                  variantColumns: variantColumns,
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
