# ShopHub

Single Flutter codebase (Web, Android, iOS) with a Customer app and an Admin
panel, backed by Supabase. Role on `profiles.role` decides which UI a signed-in
user lands on — see `PRD.md` for the full spec and a running log of what's
been built.

## Prerequisites

- Flutter SDK — installed locally at `~/development/flutter` (cloned from
  Flutter's `stable` branch directly since Homebrew wasn't available). Make
  sure it's on your PATH:
  ```
  export PATH="$PATH:$HOME/development/flutter/bin"
  ```
- iOS builds additionally need CocoaPods (`sudo gem install cocoapods`) —
  not yet installed on this machine, so iOS hasn't been build-tested here.
  Web and Android both work.

## Setup

1. Copy `.env.example` to `.env` and fill in `SUPABASE_ANON_KEY` (the anon
   *public* key from the Supabase dashboard → Project Settings → API — never
   the service role key). `SUPABASE_URL` is already filled in for project
   `qbcdavvwlsisxcvaujfp`.
2. Install packages:
   ```
   flutter pub get
   ```
3. Apply the database schema (tables, RLS policies, storage buckets) in
   `supabase/migrations/` to the Supabase project — via the SQL editor in the
   dashboard, or `supabase db push` if you have the Supabase CLI linked.
4. Regenerate model code if you change any file under `lib/**/*.dart` that has
   a `part '*.freezed.dart'` / `part '*.g.dart'` directive:
   ```
   dart run build_runner build --delete-conflicting-outputs
   ```

## Run

```
flutter run -d chrome        # web — fastest inner loop, primary target so far
flutter run -d <android-id>  # android — flutter devices to list
```

## Project layout

```
lib/
  core/       # config (env/supabase), theme, router, shared widgets, utils
  features/
    auth/                 # sign in/up, forgot password, session state
    customer/              # onboarding, home, search, cart, checkout, orders,
                            # wishlist, profile, notifications
    admin/                 # dashboard, orders, customers, coupons, categories,
                            # transactions, brands, products, reviews, roles
  shared/
    models/     # freezed models — one per Supabase table
    repositories/  # thin wrappers around supabase-flutter queries
    widgets/    # cross-feature UI (ProductCard, etc.)
supabase/
  migrations/   # schema + RLS + storage bucket policies, in apply order
```

## Conventions worth knowing before touching this codebase

- Providers are plain Riverpod (`Provider`, `FutureProvider`,
  `AsyncNotifierProvider`) — not `@riverpod` codegen, even though
  `riverpod_generator` is a dependency. This was a deliberate speed trade-off;
  don't mix in codegen providers without converting everything.
- Model JSON field renaming (snake_case ⇄ camelCase) is configured **once**,
  globally, in `build.yaml` (`field_rename: snake`). Don't add a per-class
  `@JsonSerializable(fieldRename: ...)` annotation next to `@freezed` — it
  conflicts with freezed 3's abstract-class pattern and breaks `fromJson`.
- `AppRole` enum values don't match their Postgres strings 1:1
  (`storeManager` → `'store_manager'`). Always write roles to Supabase via
  `role.dbValue` (extension in `lib/shared/models/profile.dart`), never
  `role.name`.
- Riverpod is pinned to 3.3.2, which changed some APIs from the docs you'll
  find by default: `AsyncValue.valueOrNull` doesn't exist — use `.value`
  (nullable in 3.x). `StateProvider` isn't in the main
  `package:flutter_riverpod/flutter_riverpod.dart` barrel anymore — import
  `package:flutter_riverpod/legacy.dart` wherever you use it. `StreamProvider`
  no longer has a `.stream` modifier (only `.future`, a one-shot resolve) —
  for an actual ongoing `Stream`, go to the repository/source stream
  directly instead of through the provider.
