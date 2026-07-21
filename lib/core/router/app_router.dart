import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'go_router_refresh_stream.dart';

const _authPaths = ['/sign-in', '/sign-up', '/forgot-password'];

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

      if (isAuthPath || isOnboarding || isSplash) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
      GoRoute(path: '/sign-up', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),

      // Pushed (full-screen, outside the bottom-nav shell)
      GoRoute(path: '/product/:id', builder: (context, state) => ProductDetailsScreen(productId: state.pathParameters['id']!)),
      GoRoute(path: '/checkout', builder: (context, state) => const CheckoutScreen()),
      GoRoute(path: '/checkout/success', builder: (context, state) => const OrderSuccessScreen()),
      GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
      GoRoute(path: '/orders/:id', builder: (context, state) => OrderDetailsScreen(orderId: state.pathParameters['id']!)),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/addresses', builder: (context, state) => const AddressesScreen()),

      // Bottom-nav shell
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
    ],
  );
});
