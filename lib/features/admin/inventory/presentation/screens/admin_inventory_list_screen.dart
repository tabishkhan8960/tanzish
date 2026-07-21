import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/state_views.dart';
import '../providers/admin_inventory_providers.dart';

class AdminInventoryListScreen extends ConsumerStatefulWidget {
  const AdminInventoryListScreen({super.key});

  @override
  ConsumerState<AdminInventoryListScreen> createState() => _AdminInventoryListScreenState();
}

class _AdminInventoryListScreenState extends ConsumerState<AdminInventoryListScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(adminInventoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search inventory by product name or sku...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
        ),
      ),
      body: inventoryAsync.when(
        data: (items) {
          final filtered = items.where((i) {
            final name = i.product?.name.toLowerCase() ?? '';
            final sku = i.product?.sku?.toLowerCase() ?? '';
            return name.contains(_search) || sku.contains(_search);
          }).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No inventory records found.'));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              final isLowStock = item.quantity <= item.lowStockThreshold;

              return ListTile(
                title: Text(item.product?.name ?? 'Unknown Product'),
                subtitle: Text('SKU: ${item.product?.sku ?? '-'} | Variants: ${item.variantAttributes.entries.map((e) => '\${e.key}: \${e.value}').join(', ')}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Low Stock', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    const SizedBox(width: 12),
                    Text('${item.quantity} in stock', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        final qCtrl = TextEditingController(text: item.quantity.toString());
                        final tCtrl = TextEditingController(text: item.lowStockThreshold.toString());
                        showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Update Inventory'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(controller: qCtrl, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                                const SizedBox(height: 12),
                                TextField(controller: tCtrl, decoration: const InputDecoration(labelText: 'Low Stock Threshold'), keyboardType: TextInputType.number),
                              ],
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () async {
                                  final q = int.tryParse(qCtrl.text) ?? 0;
                                  final t = int.tryParse(tCtrl.text) ?? 0;
                                  await AdminInventoryActions.upsert(item.productId, item.variantAttributes, q, t);
                                  ref.invalidate(adminInventoryProvider);
                                  if (context.mounted) Navigator.pop(c);
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const LoadingView(),
        error: (e, st) => ErrorView(message: e.toString()),
      ),
    );
  }
}
