import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/order.dart';
import '../models/product.dart';

class DashboardStats {
  const DashboardStats({
    required this.totalSales,
    required this.salesToday,
    required this.totalOrders,
    required this.ordersToday,
    required this.totalCustomers,
    required this.totalProducts,
    required this.outOfStockProducts,
    required this.recentOrders,
    required this.topProducts,
  });

  final num totalSales;
  final num salesToday;
  final int totalOrders;
  final int ordersToday;
  final int totalCustomers;
  final int totalProducts;
  final int outOfStockProducts;
  final List<Order> recentOrders;
  final List<Product> topProducts;
}

class DashboardRepository {
  DashboardRepository(this._client);

  final SupabaseClient _client;

  Future<DashboardStats> fetchStats() async {
    final results = await Future.wait<dynamic>([
      _client.from(SupabaseTables.orders).select('total, placed_at'),
      _client.from(SupabaseTables.profiles).select('id').eq('role', 'customer').count(CountOption.exact),
      _client.from(SupabaseTables.products).select('id').count(CountOption.exact),
      _client.from(SupabaseTables.inventory).select('id').eq('quantity', 0).count(CountOption.exact),
      _client
          .from(SupabaseTables.orders)
          .select('*, order_items(*), shipping_address:addresses!shipping_address_id(*), payments(*)')
          .order('placed_at', ascending: false)
          .limit(10),
      _client
          .from(SupabaseTables.products)
          .select('*, brand:brands(*), category:categories(*), product_images(*)')
          .order('rating_count', ascending: false)
          .limit(5),
    ]);

    final orderTotals = results[0] as List<dynamic>;
    
    num totalSales = 0;
    num salesToday = 0;
    int ordersToday = 0;
    
    final today = DateTime.now();
    
    for (final row in orderTotals) {
      final r = row as Map;
      final t = r['total'] as num? ?? 0;
      totalSales += t;
      
      final placedAtStr = r['placed_at'] as String?;
      if (placedAtStr != null) {
        final placed = DateTime.parse(placedAtStr);
        if (placed.year == today.year && placed.month == today.month && placed.day == today.day) {
          salesToday += t;
          ordersToday++;
        }
      }
    }
    
    final customerCount = (results[1] as PostgrestResponse).count;
    final productCount = (results[2] as PostgrestResponse).count;
    final outOfStockCount = (results[3] as PostgrestResponse).count;
    final recentOrders = (results[4] as List<dynamic>).map((r) => Order.fromJson(r as Map<String, dynamic>)).toList();
    final topProducts = (results[5] as List<dynamic>).map((r) => Product.fromJson(r as Map<String, dynamic>)).toList();

    return DashboardStats(
      totalSales: totalSales,
      salesToday: salesToday,
      totalOrders: orderTotals.length,
      ordersToday: ordersToday,
      totalCustomers: customerCount,
      totalProducts: productCount,
      outOfStockProducts: outOfStockCount,
      recentOrders: recentOrders,
      topProducts: topProducts,
    );
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(SupabaseConfig.client);
});
