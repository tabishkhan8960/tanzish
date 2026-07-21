/// Whether the catalog (categories/brands/products) is served from static
/// in-memory mock data (`lib/shared/mock_data/`) instead of Supabase.
///
/// Set to `false` once real products exist in the `products`/`categories`/
/// `brands` tables — that's the entire migration back to live data, since
/// every screen goes through `catalogRepositoryProvider`
/// (`lib/shared/repositories/catalog_repository.dart`) rather than either
/// implementation directly.
const kUseMockCatalogData = false;
