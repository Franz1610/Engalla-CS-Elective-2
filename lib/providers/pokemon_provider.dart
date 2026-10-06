import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  PokemonProvider({PokemonService? service})
    : _service = service ?? PokemonService();

  final PokemonService _service;

  List<Pokemon> _pokemon = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Pokemon> get pokemon => List.unmodifiable(_pokemon);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPokemon() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemon = await _service.fetchPokemon();
    } catch (_) {
      _errorMessage = 'Unable to load Pokémon.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}