import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/brands/presentation/screens/admin_brands_screen.dart';
import '../../features/admin/categories/presentation/screens/admin_categories_screen.dart';
import '../../features/admin/coupons/presentation/screens/admin_coupons_screen.dart';
import '../../features/admin/customers/presentation/screens/admin_customers_screen.dart';
import '../../features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/orders/presentation/screens/admin_order_details_screen.dart';
import '../../features/admin/orders/presentation/screens/admin_orders_screen.dart';
import '../../features/admin/permissions/presentation/screens/admin_permissions_screen.dart';
import '../../features/admin/presentation/widgets/admin_shell.dart';
import '../../features/admin/products/presentation/screens/admin_add_product_screen.dart';
import '../../features/admin/products/presentation/screens/admin_product_list_screen.dart';
import '../../features/admin/products/presentation/screens/admin_product_media_screen.dart';
import '../../features/admin/reviews/presentation/screens/admin_reviews_screen.dart';
import '../../features/admin/roles/presentation/screens/admin_roles_screen.dart';
import '../../features/admin/transactions/presentation/screens/admin_transactions_screen.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/customer/cart/presentation/screens/cart_screen.dart';
import '../../features/customer/checkout/presentation/screens/checkout_screen.dart';
import '../../features/customer/checkout/presentation/screens/order_success_screen.dart';
import '../../features/customer/home/presentation/screens/home_screen.dart';
import '../../features/customer/notifications/presentation/screens/notifications_screen.dart';
import '../../features/customer/onboarding/presentation/providers/onboarding_providers.dart';
import '../../features/customer/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/customer/orders/presentation/screens/order_details_screen.dart';
import '../../features/customer/orders/presentation/screens/orders_screen.dart';
import '../../features/customer/presentation/customer_shell.dart';
import '../../features/customer/product/presentation/screens/product_details_screen.dart';
import '../../features/customer/profile/presentation/screens/addresses_screen.dart';
import '../../features/customer/profile/presentation/screens/profile_screen.dart';
import '../../features/customer/search/presentation/screens/search_screen.dart';
import '../../features/customer/wishlist/presentation/screens/wishlist_screen.dart';
import '../../shared/models/profile.dart';
import 'go_router_refresh_stream.dart';

const _authPaths = ['/sign-in', '/sign-up', '/forgot-password'];

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(ref.watch(authRepositoryProvider).authStateChanges),
    redirect: (context, state) async {
      final location = state.matchedLocation;
      final isAuthPath = _authPaths.contains(location);
      final isOnboarding = location == '/onboarding';
      final isSplash = location == '/splash';

      final authAsync = ref.read(authStateChangesProvider);
      if (authAsync.isLoading && !authAsync.hasValue) {
        return isSplash ? null : '/splash';
      }

      final userId = ref.read(currentUserIdProvider);

      if (userId == null) {
        if (isAuthPath) return null;
        final seenOnboarding = await ref.read(onboardingSeenProvider.future);
        if (!seenOnboarding) return isOnboarding ? null : '/onboarding';
        return '/sign-in';
      }

      final profile = await ref.read(currentProfileProvider.future);
      final isAdmin = profile?.role == AppRole.admin;

      if (isAuthPath || isOnboarding || isSplash) {
        return isAdmin ? '/admin/dashboard' : '/home';
      }

      if (location.startsWith('/admin') && !isAdmin) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
      GoRoute(path: '/sign-up', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),

      // Customer — pushed (full-screen, outside the bottom-nav shell)
      GoRoute(path: '/product/:id', builder: (context, state) => ProductDetailsScreen(productId: state.pathParameters['id']!)),
      GoRoute(path: '/checkout', builder: (context, state) => const CheckoutScreen()),
      GoRoute(path: '/checkout/success', builder: (context, state) => const OrderSuccessScreen()),
      GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
      GoRoute(path: '/orders/:id', builder: (context, state) => OrderDetailsScreen(orderId: state.pathParameters['id']!)),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/addresses', builder: (context, state) => const AddressesScreen()),

      // Customer — bottom-nav shell
      ShellRoute(
        builder: (context, state, child) => CustomerShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/search',
            builder: (context, state) => SearchScreen(categoryId: state.uri.queryParameters['categoryId']),
          ),
          GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
          GoRoute(path: '/wishlist', builder: (context, state) => const WishlistScreen()),
          GoRoute(path: '/account', builder: (context, state) => const ProfileScreen()),
        ],
      ),

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
          GoRoute(path: '/admin/products/new', builder: (context, state) => const AdminAddProductScreen()),
          GoRoute(path: '/admin/products/media', builder: (context, state) => const AdminProductMediaScreen()),
          GoRoute(path: '/admin/products', builder: (context, state) => const AdminProductListScreen()),
          GoRoute(path: '/admin/products/:id/edit', builder: (context, state) => AdminAddProductScreen(productId: state.pathParameters['id'])),
          GoRoute(path: '/admin/reviews', builder: (context, state) => const AdminReviewsScreen()),
          GoRoute(path: '/admin/roles', builder: (context, state) => const AdminRolesScreen()),
          GoRoute(path: '/admin/permissions', builder: (context, state) => const AdminPermissionsScreen()),
        ],
      ),
    ],
  );
});
