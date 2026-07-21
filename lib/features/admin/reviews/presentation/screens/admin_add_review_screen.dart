import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/state_views.dart';
import '../domain/admin_review_actions.dart';
import '../providers/admin_reviews_providers.dart';

class AdminAddReviewScreen extends ConsumerStatefulWidget {
  const AdminAddReviewScreen({super.key, this.reviewId});

  final String? reviewId;

  @override
  ConsumerState<AdminAddReviewScreen> createState() => _AdminAddReviewScreenState();
}

class _AdminAddReviewScreenState extends ConsumerState<AdminAddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerName = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _avatar = TextEditingController();
  
  String? _productId;
  int _rating = 5;
  bool _verifiedPurchase = true;
  String _status = 'Published';
  bool _saving = false;

  @override
  void dispose() {
    _customerName.dispose();
    _title.dispose();
    _description.dispose();
    _avatar.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a product')));
      return;
    }

    setState(() => _saving = true);
    try {
      final data = {
        'product_id': _productId,
        'customer_name': _customerName.text.trim(),
        'rating': _rating,
        'review_title': _title.text.trim().isEmpty ? null : _title.text.trim(),
        'review_description': _description.text.trim().isEmpty ? null : _description.text.trim(),
        'customer_avatar': _avatar.text.trim().isEmpty ? null : _avatar.text.trim(),
        'verified_purchase': _verifiedPurchase,
        'status': _status,
      };

      if (widget.reviewId == null) {
        await AdminReviewActions.createReview(data);
      } else {
        await AdminReviewActions.updateReview(widget.reviewId!, data);
      }

      ref.invalidate(adminReviewsProvider);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review saved!')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(adminProductsForReviewProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.reviewId == null ? 'Add Review' : 'Edit Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productsAsync.when(
                  data: (products) => DropdownButtonFormField<String>(
                    value: _productId,
                    decoration: const InputDecoration(labelText: 'Select Product *'),
                    items: products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                    onChanged: (v) => setState(() => _productId = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => const Text('Could not load products'),
                ),
                const SizedBox(height: 20),
                AppTextField(controller: _customerName, label: 'Customer Name *', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                const SizedBox(height: 20),
                const Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () => setState(() => _rating = index + 1),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                AppTextField(controller: _title, label: 'Review Title (Optional)'),
                const SizedBox(height: 20),
                AppTextField(controller: _description, label: 'Review Description', maxLines: 4),
                const SizedBox(height: 20),
                AppTextField(controller: _avatar, label: 'Customer Avatar URL (Optional)'),
                const SizedBox(height: 20),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Verified Purchase'),
                  value: _verifiedPurchase,
                  onChanged: (v) => setState(() => _verifiedPurchase = v),
                ),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['Published', 'Hidden'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _status = v!),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
                    const SizedBox(width: 16),
                    PrimaryButton(label: 'Save Review', onPressed: _save, loading: _saving),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
