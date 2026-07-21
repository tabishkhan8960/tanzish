import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/brands/presentation/screens/admin_brands_screen.dart';
import '../../features/admin/categories/presentation/screens/admin_categories_screen.dart';
import '../../features/admin/coupons/presentation/screens/admin_coupons_screen.dart';
import '../../features/admin/customers/presentation/screens/admin_customers_screen.dart';
import '../../features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/orders/presentation/screens/admin_order_details_screen.dart';
import '../../features/admin/orders/presentation/screens/admin_orders_screen.dart';
import '../../features/admin/inventory/presentation/screens/admin_inventory_list_screen.dart';
import '../../features/admin/permissions/presentation/screens/admin_permissions_screen.dart';
import '../../features/admin/presentation/widgets/admin_shell.dart';
import '../../features/admin/products/presentation/screens/admin_add_product_screen.dart';
import '../../features/admin/products/presentation/screens/admin_product_list_screen.dart';
import '../../features/admin/products/presentation/screens/admin_product_media_screen.dart';
import '../../features/admin/reviews/presentation/screens/admin_add_review_screen.dart';
import '../../features/admin/reviews/presentation/screens/admin_reviews_screen.dart';
import '../../features/admin/roles/presentation/screens/admin_roles_screen.dart';
import '../../features/admin/transactions/presentation/screens/admin_transactions_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/not_authorized_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../shared/models/profile.dart';
import 'go_router_refresh_stream.dart';

const _authPaths = ['/sign-in', '/forgot-password'];

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier();
  // Drives refreshListenable from the same provider `redirect` reads below,
  // instead of a second independent subscription to the raw auth stream —
  // see the note in go_router_refresh_stream.dart for why that raced.
  ref.listen(authStateChangesProvider, (_, _) => refreshNotifier.notify());

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) async {
      final location = state.matchedLocation;
      final isAuthPath = _authPaths.contains(location);
      final isSplash = location == '/splash';
      final isNotAuthorized = location == '/not-authorized';

      final authAsync = ref.read(authStateChangesProvider);
      if (authAsync.isLoading && !authAsync.hasValue) {
        return isSplash ? null : '/splash';
      }

      final userId = ref.read(currentUserIdProvider);

      if (userId == null) {
        return isAuthPath ? null : '/sign-in';
      }

      final profile = await ref.read(currentProfileProvider.future);
      final isAdmin = profile?.role == AppRole.admin;

      if (!isAdmin) return isNotAuthorized ? null : '/not-authorized';

      if (isAuthPath || isSplash || isNotAuthorized) return '/admin/dashboard';

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: '/not-authorized', builder: (context, state) => const NotAuthorizedScreen()),

      // Admin — sidebar shell
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(path: '/admin/dashboard', builder: (context, state) => const AdminDashboardScreen()),
          GoRoute(path: '/admin/orders', builder: (context, state) => const AdminOrdersScreen()),
          GoRoute(path: '/admin/orders/:id', builder: (context, state) => AdminOrderDetailsScreen(orderId: state.pathParameters['id']!)),
          GoRoute(path: '/admin/customers', builder: (context, state) => const AdminCustomersScreen()),
          GoRoute(path: '/admin/coupons', builder: (context, state) => const AdminCouponsScreen()),
          GoRoute(path: '/admin/categories', builder: (context, state) => const AdminCategoriesScreen()),
          GoRoute(path: '/admin/transactions', builder: (context, state) => const AdminTransactionsScreen()),
          GoRoute(path: '/admin/brands', builder: (context, state) => const AdminBrandsScreen()),
          GoRoute(path: '/admin/inventory', builder: (context, state) => const AdminInventoryListScreen()),
          GoRoute(path: '/admin/products/new', builder: (context, state) => const AdminAddProductScreen()),
          GoRoute(path: '/admin/products/media', builder: (context, state) => const AdminProductMediaScreen()),
          GoRoute(path: '/admin/products', builder: (context, state) => const AdminProductListScreen()),
          GoRoute(path: '/admin/products/:id/edit', builder: (context, state) => AdminAddProductScreen(productId: state.pathParameters['id'])),
          GoRoute(path: '/admin/reviews', builder: (context, state) => const AdminReviewsScreen()),
          GoRoute(path: '/admin/reviews/new', builder: (context, state) => const AdminAddReviewScreen()),
          GoRoute(path: '/admin/reviews/:id/edit', builder: (context, state) => AdminAddReviewScreen(reviewId: state.pathParameters['id'])),
          GoRoute(path: '/admin/roles', builder: (context, state) => const AdminRolesScreen()),
          GoRoute(path: '/admin/permissions', builder: (context, state) => const AdminPermissionsScreen()),
        ],
      ),
    ],
  );
});
