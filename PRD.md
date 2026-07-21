# ShopHub — Product Requirements & Progress Log

Source of truth for requirements is `ShopHub_Ecommerce_PRD.docx`; this file is
a markdown mirror of that spec **plus a running implementation log**. Update
the log section every time you finish a meaningful chunk of work, so a new
session (human or Claude) can pick up without re-deriving context. Keep this
file and `README.md` current — don't let them drift from what's actually in
the repo.

## Spec (from the PRD doc)

**Tech stack**: Frontend Flutter (Web, Android, iOS) · Backend Supabase ·
State Riverpod · Routing GoRouter.

**Overview**: Single Flutter codebase with Admin Panel and Customer App,
both backed by the same Supabase project.

**Roles**: Admin, Customer, and (future) Store Manager, Delivery Boy.

**Admin features**: Dashboard, Products, Categories, Brands, Orders,
Customers, Coupons, Reviews, Inventory, Analytics, Reports, Settings.

Admin nav must literally match this structure (confirmed by user
2026-07-21) — Main menu: Dashboard, Order Management, Customers, Coupon Code,
Categories, Transaction, Brand. Product: Add Products, Product Media, Product
List, Product Reviews. Admin: Admin role, Control Authority. Footer: shop
profile / "Your Shop" link.

**Customer features**: Home, Search, Categories, Product Details, Wishlist,
Cart, Checkout, Orders, Profile, Notifications.

**Database tables**: profiles, roles, categories, brands, products,
product_images, inventory, addresses, cart, wishlist, orders, order_items,
payments, coupons, reviews, notifications, settings.

**Storage buckets**: product-images, category-images, brand-logos, banners,
avatars, review-images, invoices.

**Security**: Supabase Auth, RLS, role-based access, input validation.

**Development requirements**: Clean Architecture, Riverpod, GoRouter,
Material 3, responsive UI, reusable widgets, pagination, caching, realtime,
loading/error states.

**Supabase project**: ID `qbcdavvwlsisxcvaujfp`. Use the existing project —
do not create a new one. Never expose the service role key client-side.

## Design reference

Two Figma Community files (view-only — MCP has no edit/API access to either,
confirmed via repeated `get_design_context`/`get_screenshot` failures even
after the user attempted to share; working from pasted screenshots instead):

- Mobile customer app: `HVuKQH9NXTE39ALhmVhZ56` — splash/onboarding, auth,
  home, product details, cart, checkout, profile.
- Admin web dashboard: `X6uCau3lBHG9ogYCpzFWln` — sidebar nav, stat cards,
  order tables, product forms. This is what the exact admin nav list above
  was transcribed from.

Palette hand-matched from screenshots, not pulled from Figma variables:
primary red `#E63950`, see `lib/core/theme/app_colors.dart`. If Figma access
is ever restored (user duplicates the file into their own account so the MCP
server has edit rights), re-derive exact tokens from there instead.

## Implementation log

### 2026-07-21 — Branch split: admin code removed from `main`

- This repo was originally bootstrapped as a single codebase with both
  Customer and Admin UI, role-based-redirected at runtime (see log below) —
  that shape doesn't match the intended two-branch architecture (`main` =
  customer app only, `admin` = admin panel only, confirmed by user). The
  `admin` branch already had its own copy of everything (same bootstrap
  commit), so no code needed to move there — this was purely a removal pass
  on `main`.
- Removed from `main`: `lib/features/admin/**` in full; the admin-only
  repositories `customer_repository.dart`, `dashboard_repository.dart`,
  `role_permission_repository.dart`, `transaction_repository.dart`,
  `review_repository.dart` (none were referenced by any customer feature);
  the `role_permission` model (`.dart`/`.freezed.dart`/`.g.dart`); the
  now-pointless `isAdminProvider` in `auth_providers.dart`.
- `app_router.dart`: dropped all admin imports, the admin `ShellRoute` and
  its routes, and the `isAdmin` branch in the redirect callback — any
  authenticated user now simply lands on `/home`. This app no longer checks
  `profiles.role` for routing at all (`currentProfileProvider` is kept only
  because `profile_screen.dart` reads it for the account view).
- Deliberately **not** done: no guard against an admin-role account signing
  into this app — they'll just see the normal customer experience. Nothing in
  the PRD asked for that, and adding one would be speculative; revisit if the
  user wants admins blocked from the customer app.
- Left alone (not admin-specific despite being unused today):
  `settings_repository.dart` (generic key/value `settings` table, no UI
  reads it yet on either branch) and the `inventory_item` model (no
  Inventory screen exists yet on either branch). Both are neutral scaffolding,
  not something that needs to live on one branch only.
- `flutter analyze`: still 0 errors after the removal, only the same two
  pre-existing deprecation infos (`anonKey`, `RadioListTile`).
- Kept as shared (used by customer code too, not admin-only): `Review` model
  (via `catalog_repository.fetchReviews`, even though nothing calls it from a
  screen yet — the repository method itself is customer-owned code, unlike
  `review_repository.dart` which was the admin moderation repo and got
  removed).

### 2026-07-21 — Project bootstrap + core scaffolding

- Flutter SDK not preinstalled; cloned `stable` branch directly into
  `~/development/flutter` (no Homebrew available), added to PATH.
- `flutter create --project-name shophub --org com.shophub --platforms
  android,ios,web .` — scaffolded in place, preserving the pre-existing PRD
  docx and git history.
- Toolchain check (`flutter doctor`): Flutter OK, Web/Chrome OK, Android SDK
  OK (reused from the sibling `riderapp` project at
  `~/Desktop/riderapp/.android-sdk`). iOS needs CocoaPods, not installed —
  iOS untested so far; web is the primary smoke-test target.
- Dependencies added: flutter_riverpod, go_router, supabase_flutter,
  flutter_dotenv, cached_network_image, google_fonts, intl, flutter_svg,
  shimmer, freezed(+annotation), json_serializable(+annotation),
  build_runner, riverpod_generator (added but unused — see decision below),
  shared_preferences.
- `.env` / `.env.example` created. `SUPABASE_URL` filled in
  (`https://qbcdavvwlsisxcvaujfp.supabase.co`). **`SUPABASE_ANON_KEY` is a
  placeholder — blocking. The app cannot talk to Supabase until the user
  supplies the real anon/public key.**
- Full DB schema written: `supabase/migrations/0001_init.sql` (all PRD
  tables, enums, `is_admin()` helper, full RLS matrix),
  `0002_storage.sql` (7 buckets + storage policies),
  `0003_role_permissions.sql` (backs the "Control Authority" admin screen —
  not in the original PRD table list, added because the admin nav explicitly
  requires it). **Not yet applied to the live Supabase project.**
- Freezed models for every table, all under `lib/shared/models/`.
  - Decision: hit a real conflict where `@JsonSerializable(fieldRename:
    FieldRename.snake)` next to `@freezed` made json_serializable try to
    generate `fromJson` against the *abstract* class directly (which has no
    accessible constructor), throwing "Cannot populate the required
    constructor argument: id" on every model. Fixed by removing the
    per-class annotation entirely and setting `field_rename: snake` once in
    `build.yaml`. Don't reintroduce the per-class annotation.
  - `AppRole` needed manual `@JsonValue('store_manager')` /
    `@JsonValue('delivery_boy')` plus a hand-written `dbValue` extension
    (`lib/shared/models/profile.dart`) since Dart identifiers can't contain
    underscores in that casing — `.name` alone would write the wrong string
    to Postgres.
- Decision: plain Riverpod providers (`Provider`/`FutureProvider`/
  `AsyncNotifierProvider`) instead of `@riverpod` codegen, purely for
  iteration speed across ~25+ screens in one session. `riverpod_generator`
  stays in `pubspec.yaml` but is currently unused — either commit to codegen
  everywhere or drop the dependency; don't half-migrate.
- Repositories (`lib/shared/repositories/`): catalog, cart, wishlist,
  address, order, coupon, customer, transaction, role_permission, settings,
  dashboard (stats aggregation), review. All thin wrappers over
  `supabase_flutter` queries, RLS does the access control.
- Auth: `AuthRepository` + `auth_providers.dart` (auth state stream, current
  user id, current profile fetch, `isAdminProvider`). Screens: Sign In, Sign
  Up, Forgot Password, Splash, 3-slide Onboarding (persists "seen" via
  `shared_preferences`).
- `AdminShell` (sidebar, matches the exact nav list above, responsive:
  `NavigationRail`-style fixed sidebar ≥900px wide, `Drawer` below that) and
  `CustomerShell` (bottom nav: Home/Search/Cart/Wishlist/Setting, cart badge
  wired to live cart count).
- Customer: Home screen (categories row, featured grid, trending grid, promo
  banner) + Search screen (query/category filter) done and wired to real
  Supabase queries.

### 2026-07-21 (cont'd) — Full app complete, builds clean

- All customer screens built: Product Details (image carousel, similar
  products, add-to-cart), Cart, Checkout (address select/add, coupon apply,
  payment method choice, order summary → places a real order + payment row),
  Order Success, Orders list + detail, Wishlist, Profile/Account, My
  Addresses (add/set-default/delete), Notifications.
- All admin screens built, one per nav item: Dashboard (stat cards, recent
  orders table, top products), Order Management (status filter chips, status
  update dropdown in detail), Customers (search + order-history dialog),
  Coupon Code (create/toggle/delete), Categories (CRUD), Transaction
  (payments table), Brand (CRUD), Add Products (create/edit form — category
  + brand dropdowns, featured toggle), Product Media (per-product image URL
  manager), Product List (searchable table, active toggle, edit/delete),
  Product Reviews (approve/unapprove/delete), Admin role (staff list + role
  dropdown + promote-by-user-id dialog), Control Authority (permission
  matrix per role, grouped by role, admin row locked to all-allowed).
- `lib/core/router/app_router.dart` wires all of the above through a single
  GoRouter: role-based redirect (unauthenticated → onboarding-once →
  sign-in; customer → `/home`; admin → `/admin/dashboard`; non-admins bounced
  out of `/admin/*`), a `CustomerShell` (bottom nav) and `AdminShell`
  (sidebar) via `ShellRoute`, plus every pushed (non-shell) route.
- `main.dart` now does the real startup sequence:
  `EnvConfig.load()` → `SupabaseConfig.initialize()` →
  `runApp(ProviderScope(child: ShopHubApp()))`, `ShopHubApp` is a
  `ConsumerWidget` wrapping `MaterialApp.router` around `goRouterProvider`.
- **`flutter analyze`: 0 errors.** `flutter build web`: succeeds. This is the
  only build target actually verified — iOS needs CocoaPods (not installed),
  Android wasn't run end-to-end (SDK present but untested here). Treat
  `flutter run -d chrome` as the known-good smoke test path.
- Riverpod 3.3.2 API gotchas hit while wiring the router (resolved — but
  worth knowing before writing more providers):
  - `AsyncValue.valueOrNull` doesn't exist in 3.x. Use `.value` — it's the
    nullable getter now (the old non-nullable `.value` that threw on
    loading/error is gone; `.value` is safe to read directly).
  - `StateProvider` was moved out of the main `flutter_riverpod.dart` barrel
    into `package:flutter_riverpod/legacy.dart` — import that explicitly
    wherever `StateProvider` is used (five files do:
    `admin_customers_providers.dart`, `admin_orders_providers.dart`,
    `admin_products_providers.dart`, `checkout_providers.dart`,
    `search_providers.dart`).
  - `StreamProvider` no longer exposes a `.stream` modifier/getter (only
    `.future`, which resolves once to the first non-loading value — not a
    continuous stream). For `GoRouterRefreshStream`, which needs an actual
    ongoing `Stream`, we listen to `authRepository.authStateChanges`
    directly instead of going through `authStateChangesProvider.stream`.
  - None of this needed a pubspec pin change — just call-site fixes. If a
    future session hits similar "getter isn't defined" errors on Riverpod
    types, check `~/.pub-cache/hosted/pub.dev/riverpod-<version>/lib/src/`
    directly rather than assuming the older (2.x) API surface.
- `dashboard_repository.dart`'s `Future.wait([...])` needed an explicit
  `Future.wait<dynamic>([...])` type argument — the list mixes
  `PostgrestFilterBuilder` and `ResponsePostgrestBuilder` (from `.count()`
  vs plain `.select()`), which the analyzer can't unify without help.
- Deliberately left as-is (all still functional, non-blocking):
  `SupabaseClient.initialize(anonKey: ...)` is deprecated in favor of
  `publishableKey` (new Supabase API key format) — not migrating until we
  know which key format the actual project uses; `RadioListTile`'s
  `groupValue`/`onChanged` are deprecated in favor of `RadioGroup` ancestor
  widget — cosmetic, low priority.
- Product/category/brand images are entered as **comma-separated URLs** in
  the admin forms (Add Products, Product Media) — there's no real
  image_picker + Supabase Storage upload flow yet. That's the obvious next
  enhancement once there are real product photos to test with; the storage
  buckets and RLS policies for it already exist (`0002_storage.sql`).

### Next up

1. **Blocking on the user**: real Supabase anon key for `.env`
   (`SUPABASE_ANON_KEY` is still the placeholder — nothing that touches
   Supabase will work until this is filled in); explicit go-ahead to run
   the SQL migrations (`supabase/migrations/*.sql`, in order) against the
   live project.
2. Once unblocked: `flutter run -d chrome`, walk the golden path end-to-end
   (sign up → onboarding → browse → cart → checkout → order appears in
   admin Order Management), fix whatever the live database round-trip
   surfaces that a compile-time check couldn't catch (RLS policy typos,
   join/select-string mismatches, etc.).
3. Real image upload (image_picker + Supabase Storage) to replace the
   comma-separated-URL placeholder in the admin product forms.
4. iOS: install CocoaPods, then `flutter build ios` / run on a simulator to
   actually verify that target (currently untested).
5. Nice-to-haves not started: realtime order-status updates (PRD mentions
   "realtime" as a requirement — currently everything is pull/refresh-based,
   no `supabase.channel()` subscriptions yet), pagination on long lists
   (products, orders, customers all currently fetch a single page up to a
   fixed limit), Reports/Analytics beyond the dashboard stat cards.

## Ground rules for whoever picks this up next

- Don't re-litigate decisions already made and logged above (plain providers,
  freezed model shape, `build.yaml` field rename, RLS design) without a
  concrete reason — they were deliberate trade-offs for this scope/timeline.
- Update this log (new dated entry, "Next up" section) whenever you finish a
  milestone or make a non-obvious decision — that's the whole point of this
  file.
- Read `README.md` for how to actually run things day-to-day; keep both files
  in sync with reality.
