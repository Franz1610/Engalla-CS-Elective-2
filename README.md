# Supabase Pokedex

This project keeps the midterm Pokedex UI and state-management features while
loading its catalog from Supabase. It adds a price range filter and frontend
pagination with eight Pokémon/products per page.

## Supabase setup

Create a readable `products` table with these columns:

| Column | Type |
| --- | --- |
| `id` | `bigint` (primary key) |
| `name` | `text` |
| `price` | `numeric` |
| `image_url` | `text` (nullable) |
| `types` | `jsonb` (nullable) |

The app also accepts the existing midterm Pokedex columns and displays a
PokeAPI image when `image_url` is empty. Enable a SELECT policy for the
`anon`/`authenticated` roles.

Run the app with your Supabase project URL and publishable key:

```text
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-publishable-key
```

The Supabase query applies `gte`/`lte` price filters and `.range(...)`
pagination. The Riverpod provider resets to page one when the slider changes
and uses the exact filtered count to enable or disable page controls.
