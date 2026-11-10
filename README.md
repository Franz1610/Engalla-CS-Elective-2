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
| `description` | `text` (nullable) |
| `price` | `numeric` |
| `stock` | `integer` |
| `image_url` | `text` (nullable) |
| `category_id` | `bigint` |

The `products` table follows the schema used by the
[`backend` branch](https://github.com/louith/cs-elective-2-2026/tree/backend).
Enable a SELECT policy for the `anon`/`authenticated` roles. Products without
an `image_url` display a generic product image placeholder.

Put your local credentials in `.env`:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-publishable-key
```

Run the app with `flutter run -d chrome`.

The Supabase query applies `gte`/`lte` price filters and `.range(...)`
pagination. The Riverpod provider resets to page one when the slider changes
and uses the exact filtered count to enable or disable page controls.
