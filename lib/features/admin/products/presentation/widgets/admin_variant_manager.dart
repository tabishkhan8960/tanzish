import 'package:flutter/material.dart';
import '../../../../../../shared/models/inventory.dart';

class AdminVariantManager extends StatefulWidget {
  const AdminVariantManager({super.key, required this.variants, required this.onChanged});
  
  final List<Inventory> variants;
  final ValueChanged<List<Inventory>> onChanged;

  @override
  State<AdminVariantManager> createState() => _AdminVariantManagerState();
}

class _AdminVariantManagerState extends State<AdminVariantManager> {
  late List<Inventory> _variants;
  
  @override
  void initState() {
    super.initState();
    _variants = List.from(widget.variants);
  }

  void _addCustomVariant() {
    setState(() {
      _variants.add(Inventory(
        id: '', 
        productId: '', 
        updatedAt: DateTime.now(),
        variantAttributes: {'Custom': 'New Option'},
      ));
    });
    widget.onChanged(_variants);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Variants & Stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        if (_variants.isEmpty)
          const Text('No variants added. Product has a single default configuration.')
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Variant')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('SKU')),
                DataColumn(label: Text('Stock')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _variants.map((v) {
                final label = v.variantAttributes.isEmpty ? 'Default' : v.variantAttributes.entries.map((e) => '\${e.value}').join(' / ');
                return DataRow(cells: [
                  DataCell(Text(label)),
                  DataCell(TextFormField(
                    initialValue: v.price?.toString() ?? '',
                    decoration: const InputDecoration(hintText: '0.00'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final idx = _variants.indexOf(v);
                      _variants[idx] = v.copyWith(price: num.tryParse(val));
                      widget.onChanged(_variants);
                    },
                  )),
                  DataCell(TextFormField(
                    initialValue: v.sku ?? '',
                    decoration: const InputDecoration(hintText: 'SKU'),
                    onChanged: (val) {
                      final idx = _variants.indexOf(v);
                      _variants[idx] = v.copyWith(sku: val);
                      widget.onChanged(_variants);
                    },
                  )),
                  DataCell(TextFormField(
                    initialValue: v.quantity.toString(),
                    decoration: const InputDecoration(hintText: '0'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final idx = _variants.indexOf(v);
                      _variants[idx] = v.copyWith(quantity: int.tryParse(val) ?? 0);
                      widget.onChanged(_variants);
                    },
                  )),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => _variants.remove(v));
                      widget.onChanged(_variants);
                    },
                  )),
                ]);
              }).toList(),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addCustomVariant,
          icon: const Icon(Icons.add),
          label: const Text('Add custom variant'),
        ),
      ],
    );
  }
}
