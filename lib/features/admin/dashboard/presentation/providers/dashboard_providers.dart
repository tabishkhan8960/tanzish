import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/repositories/dashboard_repository.dart';

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) {
  return ref.watch(dashboardRepositoryProvider).fetchStats();
});
