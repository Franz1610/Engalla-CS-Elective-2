import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

const pokemonPageSize = 8;
const minimumProductPrice = 0.0;
const maximumProductPrice = 1000.0;

class PokemonState {
  const PokemonState({
    this.pokemon = const [],
    this.isLoading = false,
    this.errorMessage,
    this.nicknames = const {},
    this.favoriteIds = const {},
    this.selectedType,
    this.isFavoritesPanelExpanded = false,
    this.page = 0,
    this.totalCount = 0,
    this.minimumPrice = minimumProductPrice,
    this.maximumPrice = maximumProductPrice,
  });

  final List<Pokemon> pokemon;
  final bool isLoading;
  final String? errorMessage;
  final Map<int, String> nicknames;
  final Set<int> favoriteIds;
  final String? selectedType;
  final bool isFavoritesPanelExpanded;
  final int page;
  final int totalCount;
  final double minimumPrice;
  final double maximumPrice;

  bool get canGoPrevious => page > 0;
  bool get canGoNext => (page + 1) * pokemonPageSize < totalCount;

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
    int? page,
    int? totalCount,
    double? minimumPrice,
    double? maximumPrice,
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
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      maximumPrice: maximumPrice ?? this.maximumPrice,
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

  Future<void> fetchPokemon({int? page}) async {
    final requestedPage = page ?? state.page;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await service.fetchPokemon(
        minimumPrice: state.minimumPrice,
        maximumPrice: state.maximumPrice,
        page: requestedPage,
        pageSize: pokemonPageSize,
      );
      state = state.copyWith(
        pokemon: result.pokemon,
        totalCount: result.totalCount,
        page: requestedPage,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load Pokémon.\n$error',
      );
    }
  }

  Future<void> setPriceRange(double start, double end) async {
    state = state.copyWith(minimumPrice: start, maximumPrice: end, page: 0);
    await fetchPokemon(page: 0);
  }

  Future<void> goToPage(int page) {
    if (page < 0 || (!state.canGoNext && page > state.page)) {
      return Future.value();
    }
    return fetchPokemon(page: page);
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
