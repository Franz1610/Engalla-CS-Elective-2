import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends ConsumerStatefulWidget {
  const PokemonListScreen({super.key});

  @override
  ConsumerState<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends ConsumerState<PokemonListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pokemonProvider.notifier).fetchPokemon());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonProvider);
    final notifier = ref.read(pokemonProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => _showFavorites(context),
            icon: Badge(
              label: Text('${state.favoritePokemon.length}'),
              isLabelVisible: state.favoritePokemon.isNotEmpty,
              child: const Icon(Icons.favorite_border),
            ),
          ),
          IconButton(
            tooltip: 'Refresh Pokémon',
            onPressed: state.isLoading ? null : notifier.fetchPokemon,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notifier.fetchPokemon,
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PokemonState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: _MessageState(
              icon: Icons.cloud_off_outlined,
              message: state.errorMessage!,
              actionLabel: 'Try again',
              onAction: ref.read(pokemonProvider.notifier).fetchPokemon,
            ),
          ),
        ],
      );
    }

    if (state.pokemon.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: const _MessageState(
              icon: Icons.catching_pokemon,
              message: 'No Pokémon found.',
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _TypeFilter(state: state)),
        if (state.filteredPokemon.isEmpty)
          const SliverFillRemaining(
            child: _MessageState(
              icon: Icons.filter_alt_off,
              message: 'No Pokémon match this type.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final pokemon = state.filteredPokemon[index];
                return PokemonCard(
                  pokemon: pokemon,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          PokemonDetailScreen(pokemonId: pokemon.id),
                    ),
                  ),
                );
              }, childCount: state.filteredPokemon.length),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
            ),
          ),
      ],
    );
  }

  void _showFavorites(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _FavoritesPanel(
        onOpen: (id) {
          Navigator.pop(context);
          Navigator.of(this.context).push(
            MaterialPageRoute<void>(
              builder: (_) => PokemonDetailScreen(pokemonId: id),
            ),
          );
        },
      ),
    );
  }
}

class _TypeFilter extends ConsumerWidget {
  const _TypeFilter({required this.state});

  final PokemonState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              key: ValueKey(state.selectedType),
              initialValue: state.selectedType,
              decoration: const InputDecoration(
                labelText: 'Filter by type',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All types'),
                ),
                ...state.availableTypes.map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type.toUpperCase()),
                  ),
                ),
              ],
              onChanged: ref.read(pokemonProvider.notifier).setTypeFilter,
            ),
          ),
          if (state.selectedType != null)
            IconButton(
              tooltip: 'Clear filter',
              onPressed: () =>
                  ref.read(pokemonProvider.notifier).setTypeFilter(null),
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
    );
  }
}

class _FavoritesPanel extends ConsumerWidget {
  const _FavoritesPanel({required this.onOpen});

  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonProvider);
    final notifier = ref.read(pokemonProvider.notifier);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Favorite Pokémon'),
            trailing: IconButton(
              onPressed: notifier.toggleFavoritesPanel,
              icon: Icon(
                state.isFavoritesPanelExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
              ),
            ),
          ),
          if (state.isFavoritesPanelExpanded)
            if (state.favoritePokemon.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No Pokémon have been favorited yet.'),
              )
            else
              ...state.favoritePokemon.map(
                (pokemon) => ListTile(
                  leading: Image.network(pokemon.imageUrl, width: 48),
                  title: Text(pokemon.name.toUpperCase()),
                  subtitle: Text(state.nicknames[pokemon.id] ?? ''),
                  onTap: () => onOpen(pokemon.id),
                  trailing: IconButton(
                    onPressed: () => notifier.toggleFavorite(pokemon.id),
                    icon: const Icon(Icons.favorite, color: Colors.red),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
