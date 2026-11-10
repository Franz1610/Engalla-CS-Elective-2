import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/favorites_panel.dart';
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
        title: const Text('Shop'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Saved products',
            onPressed: () => _showFavorites(context),
            icon: Badge(
              label: Text('${state.favoritePokemon.length}'),
              isLabelVisible: state.favoritePokemon.isNotEmpty,
              child: const Icon(Icons.favorite_border),
            ),
          ),
          IconButton(
            tooltip: 'Refresh products',
            onPressed: state.isLoading ? null : notifier.fetchPokemon,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notifier.fetchPokemon,
        child: Column(
          children: [
            _PriceFilter(state: state),
            Expanded(child: _buildBody(context, state)),
            _PaginationControls(
              state: state,
              onPageChanged: notifier.goToPage,
            ),
          ],
        ),
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
              message: 'No products found.',
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
              message: 'No products match this category.',
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
      builder: (_) => FavoritesPanel(
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
                labelText: 'Filter by category',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All categories'),
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

  class _PriceFilter extends ConsumerWidget {
    const _PriceFilter({required this.state});

    final PokemonState state;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Card(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Price: \$${state.minimumPrice.toStringAsFixed(0)} - '
                  '\$${state.maximumPrice.toStringAsFixed(0)}',
                ),
              ),
              RangeSlider(
                values: RangeValues(state.minimumPrice, state.maximumPrice),
                min: minimumProductPrice,
                max: maximumProductPrice,
                divisions: 100,
                labels: RangeLabels(
                  '\$${state.minimumPrice.toStringAsFixed(0)}',
                  '\$${state.maximumPrice.toStringAsFixed(0)}',
                ),
                onChanged: state.isLoading
                    ? null
                    : (values) => ref.read(pokemonProvider.notifier).setPriceRange(
                          values.start,
                          values.end,
                        ),
              ),
            ],
          ),
        ),
      );
    }
  }

  class _PaginationControls extends StatelessWidget {
    const _PaginationControls({
      required this.state,
      required this.onPageChanged,
    });

    final PokemonState state;
    final ValueChanged<int> onPageChanged;

    @override
    Widget build(BuildContext context) {
      final pageCount = state.totalCount == 0
          ? 0
          : (state.totalCount + pokemonPageSize - 1) ~/ pokemonPageSize;
      return SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Previous page',
              onPressed: state.isLoading || !state.canGoPrevious
                  ? null
                  : () => onPageChanged(state.page - 1),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(pageCount == 0
                ? 'No pages'
                : 'Page ${state.page + 1} of $pageCount'),
            IconButton(
              tooltip: 'Next page',
              onPressed: state.isLoading || !state.canGoNext
                  ? null
                  : () => onPageChanged(state.page + 1),
              icon: const Icon(Icons.chevron_right),
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
