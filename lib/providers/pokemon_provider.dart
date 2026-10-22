import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonState {
  const PokemonState({
    this.pokemon = const [],
    this.isLoading = false,
    this.errorMessage,
    this.nicknames = const {},
    this.favoriteIds = const {},
    this.selectedType,
    this.isFavoritesPanelExpanded = false,
  });

  final List<Pokemon> pokemon;
  final bool isLoading;
  final String? errorMessage;
  final Map<int, String> nicknames;
  final Set<int> favoriteIds;
  final String? selectedType;
  final bool isFavoritesPanelExpanded;

  List<Pokemon> get filteredPokemon => selectedType == null
      ? pokemon
      : pokemon.where((item) => item.types.contains(selectedType)).toList();

  List<Pokemon> get favoritePokemon =>
      pokemon.where((item) => favoriteIds.contains(item.id)).toList();

  List<String> get availableTypes =>
      pokemon.expand((item) => item.types).toSet().toList()..sort();

  PokemonState copyWith({
    List<Pokemon>? pokemon,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    Map<int, String>? nicknames,
    Set<int>? favoriteIds,
    String? selectedType,
    bool clearSelectedType = false,
    bool? isFavoritesPanelExpanded,
  }) {
    return PokemonState(
      pokemon: pokemon ?? this.pokemon,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      nicknames: nicknames ?? this.nicknames,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedType: clearSelectedType
          ? null
          : selectedType ?? this.selectedType,
      isFavoritesPanelExpanded:
          isFavoritesPanelExpanded ?? this.isFavoritesPanelExpanded,
    );
  }
}

final pokemonProvider = NotifierProvider<PokemonNotifier, PokemonState>(
  PokemonNotifier.new,
);

class PokemonNotifier extends Notifier<PokemonState> {
  PokemonNotifier({this._service});

  PokemonService? _service;

  PokemonService get service => _service ??= PokemonService();

  @override
  PokemonState build() {
    ref.onDispose(() => _service?.dispose());
    return const PokemonState();
  }

  Future<void> fetchPokemon() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final pokemon = await service.fetchPokemon();
      state = state.copyWith(pokemon: pokemon, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load Pokémon.',
      );
    }
  }

  void setNickname(int pokemonId, String nickname) {
    final updated = {...state.nicknames};
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      updated.remove(pokemonId);
    } else {
      updated[pokemonId] = trimmed;
    }
    state = state.copyWith(nicknames: updated);
  }

  void removeNickname(int pokemonId) {
    final updated = {...state.nicknames}..remove(pokemonId);
    state = state.copyWith(nicknames: updated);
  }

  void toggleFavorite(int pokemonId) {
    final updated = {...state.favoriteIds};
    if (!updated.add(pokemonId)) {
      updated.remove(pokemonId);
    }
    state = state.copyWith(favoriteIds: updated);
  }

  void setTypeFilter(String? type) {
    state = type == null
        ? state.copyWith(clearSelectedType: true)
        : state.copyWith(selectedType: type);
  }

  void toggleFavoritesPanel() {
    state = state.copyWith(
      isFavoritesPanelExpanded: !state.isFavoritesPanelExpanded,
    );
  }
}
