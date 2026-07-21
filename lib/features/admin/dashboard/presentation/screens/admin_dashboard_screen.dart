import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../../../../shared/widgets/order_status_badge.dart';
import '../providers/dashboard_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: statsAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: 'Could not load dashboard', onRetry: () => ref.invalidate(dashboardStatsProvider)),
        data: (stats) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardStatsProvider),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(label: 'Total Sales', value: formatCurrency(stats.totalSales), icon: Icons.payments_outlined),
                  _StatCard(label: 'Sales Today', value: formatCurrency(stats.salesToday), icon: Icons.monetization_on_outlined, accent: AppColors.primary),
                  _StatCard(label: 'Total Orders', value: '${stats.totalOrders}', icon: Icons.receipt_long_outlined),
                  _StatCard(label: 'Orders Today', value: '${stats.ordersToday}', icon: Icons.shopping_bag_outlined, accent: AppColors.primary),
                  _StatCard(label: 'Customers', value: '${stats.totalCustomers}', icon: Icons.people_outline),
                  _StatCard(label: 'Products', value: '${stats.totalProducts}', icon: Icons.inventory_2_outlined),
                  _StatCard(
                    label: 'Out of Stock',
                    value: '${stats.outOfStockProducts}',
                    icon: Icons.warning_amber_rounded,
                    accent: stats.outOfStockProducts > 0 ? AppColors.error : null,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _RecentOrders(orders: stats.recentOrders)),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: _TopProducts(products: stats.topProducts)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, this.accent});
  final String label;
  final String value;
  final IconData icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent ?? AppColors.primary),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _RecentOrders extends StatelessWidget {
  const _RecentOrders({required this.orders});
  final List orders;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(onPressed: () => context.go('/admin/orders'), child: const Text('View all')),
            ],
          ),
          const SizedBox(height: 8),
          if (orders.isEmpty)
            const Padding(padding: EdgeInsets.all(16), child: Text('No orders yet', style: TextStyle(color: AppColors.textSecondary)))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Status')),
                ],
                rows: [
                  for (final order in orders)
                    DataRow(
                      onSelectChanged: (_) => context.push('/admin/orders/${order.id}'),
                      cells: [
                        DataCell(Text(order.orderNumber)),
                        DataCell(Text(formatDate(order.placedAt))),
                        DataCell(Text(formatCurrency(order.total))),
                        DataCell(OrderStatusBadge(status: order.status)),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TopProducts extends StatelessWidget {
  const _TopProducts({required this.products});
  final List products;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (products.isEmpty)
            const Text('No products yet', style: TextStyle(color: AppColors.textSecondary))
          else
            for (final product in products)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.image_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Text(formatCurrency(product.price), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
