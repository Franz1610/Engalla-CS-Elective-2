import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  static const _pokemonLimit = 30;
  static final _endpoint = Uri.parse(
    'https://pokeapi.co/api/v2/pokemon?limit=$_pokemonLimit&offset=0',
  );

  final http.Client _client;

  Future<List<Pokemon>> fetchPokemon() async {
    final response = await _client.get(_endpoint);

    if (response.statusCode != 200) {
      throw Exception('Unable to load Pokemon right now.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final results = decoded['results'] as List<dynamic>? ?? [];

    return results
        .take(_pokemonLimit)
        .map((item) => Pokemon.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  void dispose() {
    _client.close();
  }
}
