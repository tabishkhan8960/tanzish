import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../repositories/address_repository.dart';

Future<void> showAddressFormSheet(BuildContext context, WidgetRef ref, {required String userId}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => _AddressFormSheet(userId: userId),
  );
}

class _AddressFormSheet extends ConsumerStatefulWidget {
  const _AddressFormSheet({required this.userId});
  final String userId;

  @override
  ConsumerState<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends ConsumerState<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _postal = TextEditingController();
  final _country = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _line1, _line2, _city, _state, _postal, _country]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(addressRepositoryProvider).upsert({
        'user_id': widget.userId,
        'full_name': _name.text.trim(),
        'phone': _phone.text.trim(),
        'address_line1': _line1.text.trim(),
        'address_line2': _line2.text.trim(),
        'city': _city.text.trim(),
        'state': _state.text.trim(),
        'postal_code': _postal.text.trim(),
        'country': _country.text.trim(),
      });
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('New Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              AppTextField(controller: _name, hint: 'Full name', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              AppTextField(controller: _phone, hint: 'Phone number', keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              AppTextField(controller: _line1, hint: 'Address line 1', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              AppTextField(controller: _line2, hint: 'Address line 2 (optional)'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: AppTextField(controller: _city, hint: 'City', validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(controller: _state, hint: 'State')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: AppTextField(controller: _postal, hint: 'Postal code')),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(controller: _country, hint: 'Country', validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'Save Address', onPressed: _save, loading: _saving),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
