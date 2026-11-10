# Supabase Shop

This project uses the midterm Flutter structure and Riverpod state management
to build a shop catalog backed by Supabase. It adds a price range filter and
frontend pagination with eight products per page.

## Supabase setup

Create a readable `products` table with these columns:

| Column | Type |
| --- | --- |
| `id` | `bigint` (primary key) |
| `name` | `text` |
| `price` | `numeric` |
| `image_url` | `text` (nullable) |
| `types` | `jsonb` (nullable) |

Enable a SELECT policy for the `anon`/`authenticated` roles. Products without
an `image_url` display a generic product image placeholder.

Run the app with your Supabase project URL and publishable key:

```text
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-publishable-key
```

The Supabase query applies `gte`/`lte` price filters and `.range(...)`
pagination. The Riverpod provider resets to page one when the slider changes
and uses the exact filtered count to enable or disable page controls.
