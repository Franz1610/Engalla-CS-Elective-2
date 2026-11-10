import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/pokemon.dart';

class PokemonPage {
  const PokemonPage({required this.pokemon, required this.totalCount});

  final List<Pokemon> pokemon;
  final int totalCount;
}

class PokemonService {
  PokemonService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<PokemonPage> fetchPokemon({
    required double minimumPrice,
    required double maximumPrice,
    required int page,
    int pageSize = 8,
  }) async {
    final start = page * pageSize;
    final end = start + pageSize - 1;
    final rows = await _client
        .from('products')
        .select('*')
        .gte('price', minimumPrice)
        .lte('price', maximumPrice)
        .order('id')
        .range(start, end);
    final countResponse = await _client
        .from('products')
        .select('*')
        .gte('price', minimumPrice)
        .lte('price', maximumPrice)
        .count(CountOption.exact);

    return PokemonPage(
      pokemon: rows.map(Pokemon.fromProductMap).toList(),
      totalCount: countResponse.count,
    );
  }

  void dispose() {}
}
