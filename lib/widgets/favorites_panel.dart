import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokemon_provider.dart';

class FavoritesPanel extends ConsumerWidget {
  const FavoritesPanel({required this.onOpen, super.key});

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
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ...state.favoritePokemon.map(
                      (pokemon) => ListTile(
                        leading: Image.network(pokemon.imageUrl, width: 48),
                        title: Text(pokemon.name.toUpperCase()),
                        subtitle: Text(state.nicknames[pokemon.id] ?? ''),
                        onTap: () => onOpen(pokemon.id),
                        trailing: IconButton(
                          onPressed: () =>
                              notifier.toggleFavorite(pokemon.id),
                          icon: const Icon(Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}