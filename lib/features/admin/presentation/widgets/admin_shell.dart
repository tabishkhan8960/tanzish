import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class _AdminNavItem {
  const _AdminNavItem(this.icon, this.label, this.path);
  final IconData icon;
  final String label;
  final String path;
}

const _mainMenu = [
  _AdminNavItem(Icons.dashboard_outlined, 'Dashboard', '/admin/dashboard'),
  _AdminNavItem(Icons.receipt_long_outlined, 'Order Management', '/admin/orders'),
  _AdminNavItem(Icons.people_outline, 'Customers', '/admin/customers'),
  _AdminNavItem(Icons.confirmation_number_outlined, 'Coupon Code', '/admin/coupons'),
  _AdminNavItem(Icons.category_outlined, 'Categories', '/admin/categories'),
  _AdminNavItem(Icons.swap_horiz, 'Transaction', '/admin/transactions'),
  _AdminNavItem(Icons.local_offer_outlined, 'Brand', '/admin/brands'),
];

const _productMenu = [
  _AdminNavItem(Icons.inventory_2_outlined, 'Inventory', '/admin/inventory'),
  _AdminNavItem(Icons.add_box_outlined, 'Add Products', '/admin/products/new'),
  _AdminNavItem(Icons.image_outlined, 'Product Media', '/admin/product_media'),
  _AdminNavItem(Icons.list_alt_outlined, 'Product List', '/admin/products'),
  _AdminNavItem(Icons.star_outline, 'Product Reviews', '/admin/reviews'),
];

const _adminMenu = [
  _AdminNavItem(Icons.admin_panel_settings_outlined, 'Admin role', '/admin/roles'),
  _AdminNavItem(Icons.security_outlined, 'Control Authority', '/admin/permissions'),
];

class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final profile = ref.watch(currentProfileProvider).value;
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final sidebar = _Sidebar(location: location, profileName: profile?.fullName ?? 'Admin');

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 260, child: sidebar),
            const VerticalDivider(width: 1, color: AppColors.border),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ShopHub Admin')),
      drawer: Drawer(child: sidebar),
      body: child,
    );
  }
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.location, required this.profileName});

  final String location;
  final String profileName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.storefront_rounded, color: AppColors.primary),
                SizedBox(width: 8),
                Text('ShopHub', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const _MenuLabel('Main menu'),
                for (final item in _mainMenu) _NavTile(item: item, selected: location.startsWith(item.path)),
                const _MenuLabel('Product'),
                for (final item in _productMenu)
                  _NavTile(
                    item: item,
                    selected: location == item.path || (item.label == 'Product List' && location == '/admin/products'),
                  ),
                const _MenuLabel('Admin'),
                for (final item in _adminMenu) _NavTile(item: item, selected: location.startsWith(item.path)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 18, backgroundColor: AppColors.background, child: Icon(Icons.person, color: AppColors.textSecondary)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(profileName, style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                      const Text('Admin', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Sign out',
                  icon: const Icon(Icons.logout, size: 18),
                  onPressed: () => ref.read(authRepositoryProvider).signOut(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: OutlinedButton.icon(
              onPressed: () => GoRouter.of(context).go('/home'),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Your Shop'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.item, required this.selected});

  final _AdminNavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => GoRouter.of(context).go(item.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(item.icon, size: 20, color: selected ? Colors.white : AppColors.textSecondary),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
