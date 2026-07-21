import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../providers/admin_products_providers.dart';

class AdminProductListScreen extends ConsumerWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(icon: const Icon(Icons.add), tooltip: 'Add product', onPressed: () => context.go('/admin/products/new')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search products'),
              onChanged: (v) => ref.read(adminProductsSearchProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) => products.isEmpty
                  ? const EmptyView(message: 'No products yet', icon: Icons.inventory_2_outlined)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Product')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Brand')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Active')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          for (final p in products)
                            DataRow(cells: [
                              DataCell(SizedBox(width: 220, child: Text(p.name, overflow: TextOverflow.ellipsis))),
                              DataCell(Text(p.category?.name ?? '—')),
                              DataCell(Text(p.brand?.name ?? '—')),
                              DataCell(Text(formatCurrency(p.price))),
                              DataCell(Switch(
                                value: p.isActive,
                                onChanged: (v) async {
                                  await AdminProductActions.setActive(p.id, v);
                                  ref.invalidate(adminProductsProvider);
                                },
                              )),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => context.go('/admin/products/${p.id}/edit')),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                    onPressed: () async {
                                      await AdminProductActions.delete(p.id);
                                      ref.invalidate(adminProductsProvider);
                                    },
                                  ),
                                ],
                              )),
                            ]),
                        ],
                      ),
                    ),
              loading: () => const LoadingView(),
              error: (e, _) => const ErrorView(message: 'Could not load products'),
            ),
          ),
        ],
      ),
    );
  }
}
