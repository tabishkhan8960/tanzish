import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../models/order.dart';
import '../models/product.dart';

class DashboardStats {
  const DashboardStats({
    required this.totalSales,
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalProducts,
    required this.outOfStockProducts,
    required this.recentOrders,
    required this.topProducts,
  });

  final num totalSales;
  final int totalOrders;
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
      _client.from(SupabaseTables.orders).select('total'),
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
    final totalSales = orderTotals.fold<num>(0, (sum, row) => sum + ((row as Map)['total'] as num? ?? 0));
    final customerCount = (results[1] as PostgrestResponse).count;
    final productCount = (results[2] as PostgrestResponse).count;
    final outOfStockCount = (results[3] as PostgrestResponse).count;
    final recentOrders = (results[4] as List<dynamic>).map((r) => Order.fromJson(r as Map<String, dynamic>)).toList();
    final topProducts = (results[5] as List<dynamic>).map((r) => Product.fromJson(r as Map<String, dynamic>)).toList();

    return DashboardStats(
      totalSales: totalSales,
      totalOrders: orderTotals.length,
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
