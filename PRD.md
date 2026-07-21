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

### 2026-07-22 (cont'd) — Image upload button/drag-drop did nothing: stale web plugin registrant, not a code bug

- User reported the whole upload flow silently doing nothing: Browse button
  no-op, drag-and-drop no-op, no previews, no console errors.
- Root cause had nothing to do with the widget/controller code from the
  entry above — it was a **stale generated web plugin registrant**. Flutter
  web plugin wiring lives in an auto-generated
  `.dart_tool/flutter_build/<hash>/web_plugin_registrant.dart`; the one on
  disk only registered `app_links_web`, `shared_preferences_web`, and
  `url_launcher_web` — **`image_picker_for_web` and `desktop_drop`'s web
  implementation were never registered at all**, even though both resolved
  fine in `pubspec.lock` and `flutter analyze`/`flutter build web` both
  passed clean. Confirmed by grepping the compiled `build/web/main.dart.js`:
  `desktop_drop` appeared once (barely referenced) and
  `flt-image-picker-inputs` (a literal from `image_picker_for_web`'s DOM
  injection code) didn't appear **at all** — dart2js had tree-shaken the
  entire web implementation away because nothing reachable ever registered
  it as the platform implementation.
  - Confirmed the stale registrant predated this feature (referenced
    `app_links_web`/`url_launcher_web`, neither of which is even in this
    app's `pubspec.yaml` — leftover from an unrelated cached build).
  - Why `flutter analyze` and even `flutter build web` succeeding didn't
    catch this: plugin registration is a codegen step keyed off a build
    hash, decoupled from the Dart analyzer and from whether the build
    *succeeds* — a stale/wrong registrant still compiles fine, it just
    silently omits the plugin, so every call into `image_picker`/
    `desktop_drop` on web hits a no-op/absent platform implementation
    instead of throwing.
  - Fix: `flutter clean` (wipes `.dart_tool/`, forcing full regeneration) →
    `flutter pub get` → `flutter build web`. The regenerated registrant
    correctly includes `DesktopDropWeb.registerWith(registrar)` and
    `ImagePickerPlugin.registerWith(registrar)`, and `main.dart.js` now
    contains the `flt-image-picker-inputs` string and 4 `desktop_drop`
    references.
  - **Lesson for next time a newly-added web plugin silently no-ops** (button
    does nothing, no error): check
    `.dart_tool/flutter_build/*/web_plugin_registrant.dart` for the missing
    plugin before assuming it's an application-code bug — `flutter clean`
    first, cheaply, before spending time debugging widget code that's
    probably fine.
- Not yet re-verified against a live click/drop in a real browser from this
  session (same headless-automation limits as the entry below) — asked the
  user to retest since they have real mouse/file-dialog interaction.

### 2026-07-22 — Real product image upload, replacing the comma-separated-URL placeholder

- User asked for a Shopify/WooCommerce-style upload experience on the Add
  Products / Product Media screens, replacing the "paste image URLs" text
  field flagged as a known gap since the 2026-07-21 bootstrap log entry.
- New shared pieces (`lib/shared/widgets/`, reused by both screens so they
  don't diverge again):
  - `product_image_manager.dart` — `ProductImageManager extends ChangeNotifier`
    owns the working image list (existing DB-backed URLs + newly picked local
    files), independent of any one screen. Validates (type: jpg/jpeg/png/webp,
    size: 5 MB) and compresses (via `package:image`, downscale to a 1600px
    max dimension + re-encode JPEG q85) **at pick time**, so a bad file
    surfaces immediately rather than at save. The actual Supabase Storage
    upload happens lazily, only when `uploadPendingAndGetOrderedUrls()` is
    called at save time — nothing hits Storage for a product the admin
    abandons without saving. Per-file retry on failure; `uploadPending...`
    throws if any entry is still failed, so the caller doesn't save a product
    with missing images.
  - `product_image_upload_field.dart` — the actual widget: `desktop_drop`'s
    `DropTarget` for drag-and-drop (works on web) + `image_picker`'s
    `pickMultiImage` for click-to-browse, a `Wrap` of thumbnail tiles with
    `Draggable`/`DragTarget` per tile for drag-to-reorder, a "Primary" badge
    on index 0, per-tile delete button, and an uploading/failed-with-retry
    overlay per tile.
  - `core/utils/image_processing.dart` — the pure validation/compression
    functions, kept separate from the widget so they're easy to unit-test
    later if it comes to that.
- `AdminProductActions.replaceImages` now also cleans up Storage: before
  swapping `product_images` rows, it diffs old vs. new URL sets and deletes
  the now-orphaned objects from the `product-images` bucket (best-effort —
  a delete failure there doesn't block the product save). Previously this
  method only ever touched the DB rows and silently leaked storage objects
  when images were replaced or removed.
- **Schema gap found and fixed**: `product_images` had no `created_at`
  column, but the DB spec (and this feature) calls for one. Added
  `supabase/migrations/0004_product_images_created_at.sql` — **not yet
  applied to the live project**; per the user's standing instruction, DB
  changes are handed to them as SQL to run manually rather than executed
  directly:
  ```sql
  alter table product_images
    add column if not exists created_at timestamptz not null default now();
  ```
- Progress indication is per-tile (spinner while uploading, error+retry
  overlay on failure) rather than a byte-accurate percentage — supabase_flutter's
  `uploadBinary` doesn't expose upload-progress callbacks in its public API,
  so a fabricated percentage wasn't worth faking.
- New deps: `image_picker`, `desktop_drop`, `image`, `uuid`, `cross_file`
  (the last promoted from transitive since it's referenced directly for the
  `XFile` type shared between `image_picker` and `desktop_drop`).
- `flutter analyze`: 0 errors (same one pre-existing `anonKey` info).
  `flutter build web`: succeeds.
- **Not yet verified against a live upload** — headless Chromium (this
  environment's only browser automation path) can't drive Flutter Web's
  canvas-rendered form fields or native OS file-picker dialogs, so this needs
  a real hands-on pass: open Add Products, drag a few images in, reorder,
  delete one, save, then confirm the rows in `product_images` and the
  objects in the `product-images` bucket both look right.

### 2026-07-21 — Real anon key added; fixed a router bug that hung the app on `/splash` forever

- User supplied the real `SUPABASE_ANON_KEY` for project `qbcdavvwlsisxcvaujfp` —
  filled into `.env` here (and into `customer/.env` too, same project/key).
  `flutter build web` + a headless-Chromium smoke test (Playwright, since
  neither `chromium-cli` nor a real display was available in this
  environment) confirmed the project is reachable and the key is accepted
  (`GET /auth/v1/settings` → 200).
- That smoke test surfaced a **real, previously-unexercised bug**: with a
  syntactically valid key, the app got past the placeholder-key crash from
  the previous log entry but then hung forever on the splash screen — never
  reaching sign-in. Root cause was a race in the router, not anything to do
  with the branch split above:
  - `redirect` gated on `ref.read(authStateChangesProvider).isLoading`
    (Riverpod's own subscription to the Supabase auth stream), while
    `GoRouterRefreshStream` held a **second, independent** subscription to
    the exact same stream purely to call `notifyListeners()`.
  - Confirmed via temporary debug prints: the auth stream does emit exactly
    once at startup (`AuthChangeEvent.initialSession`, since there's no
    stored session), and both subscriptions do receive it — but
    `GoRouterRefreshStream`'s raw `.listen()` callback fires (and triggers a
    `redirect` re-run) one microtask *before* Riverpod's own internal
    listener updates `authStateChangesProvider`'s state. So the re-run of
    `redirect` still read stale `AsyncLoading`, returned `/splash` again, and
    since the underlying stream never emits a second time (no further
    sign-in/out happens), nothing ever triggered a third `redirect` — the
    app was stuck permanently, not just slow.
  - Fix: replaced the stream-based `GoRouterRefreshStream` with a plain
    `GoRouterRefreshNotifier extends ChangeNotifier`, driven via
    `ref.listen(authStateChangesProvider, (_, _) => refreshNotifier.notify())`
    inside `goRouterProvider` itself — so refreshListenable and the value
    `redirect` reads are now the *same* Riverpod subscription, eliminating
    the race by construction. Applied identically on `customer` (same
    pattern, same latent bug, just never reached there either before today).
  - `go_router_refresh_stream.dart` kept its filename but no longer holds a
    `Stream`-taking class — see the doc comment on `GoRouterRefreshNotifier`
    for the full "why," in case anyone's tempted to revert to the stream
    version, which looks simpler but is broken.
- Verified after the fix: fresh headless run reaches the sign-in screen
  (`Welcome Back!`) reliably. `flutter analyze`: 0 errors (same one
  pre-existing `anonKey` deprecation info).
- **Not done yet, next blocker for an actual login round-trip**: the SQL
  migrations in `supabase/migrations/` still haven't been applied to the
  live project (no `supabase` CLI installed in this environment, and no
  dashboard/service-role access) — signing in will fail past the auth step
  until `profiles`/`products`/etc. exist. No admin-role account exists yet
  either.

### 2026-07-21 — Branch split: customer code removed from `admin`

- Mirror of the same cleanup already done on `main` (see that branch's log):
  this repo was originally bootstrapped as one unified codebase with both
  Customer and Admin UI, committed identically to both branches. Removed
  everything customer-only from `admin` so it's admin UI only.
- Removed: `lib/features/customer/**` in full; `sign_up_screen.dart` (public
  self-registration doesn't belong in an admin panel — admins are provisioned
  via the existing "Admin role" promote-by-user-id flow, not self-signup;
  `signUp` isn't called anywhere else in this branch now) and its `/sign-up`
  route + the now-dead "Sign Up" link on the sign-in screen; the customer-only
  repositories `address_repository.dart`, `cart_repository.dart`,
  `wishlist_repository.dart`; the `wishlist_item` and `notification_item`
  models; `lib/shared/widgets/address_form_sheet.dart` (only ever used by the
  now-removed customer addresses screen).
- Kept, even though they look customer-flavored, because something in the
  admin UI (or a shared model) still depends on them: `address.dart` model
  (`Order.shippingAddress` embeds one, and Admin Order Details displays it);
  `cart_item.dart` model (`order_repository.placeOrder(items: List<CartItem>)`
  needs it to compile, even though no admin screen calls `placeOrder`);
  `settings_repository.dart` (generic key/value store, unused by anyone on
  either branch yet — not customer-specific, left alone).
- `app_router.dart`: dropped the onboarding route/provider reference, the
  customer `ShellRoute` and its routes, `/sign-up`. Replaced the old
  "non-admin → `/home`" redirect (there's no `/home` here anymore) with a new
  `NotAuthorizedScreen` at `/not-authorized` — any signed-in non-admin account
  lands there instead of a customer UI that no longer exists in this app, with
  a sign-out button so they can try a different account.
- Fixed two real cross-feature breaks the deletion caused (`flutter analyze`
  caught both immediately): `admin_add_product_screen.dart` was importing
  `productProvider` from the customer home feature's providers file for its
  edit-mode fetch-by-id — moved that provider into
  `admin_products_providers.dart` instead of reaching into a folder that no
  longer exists.
- `flutter analyze`: 0 errors (one pre-existing `anonKey` deprecation info,
  same as before). `flutter build web`: succeeds.

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
