import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokemon_provider.dart';
import '../widgets/favorites_panel.dart';

class PokemonDetailScreen extends ConsumerStatefulWidget {
  const PokemonDetailScreen({required this.pokemonId, super.key});

  final int pokemonId;

  @override
  ConsumerState<PokemonDetailScreen> createState() =>
      _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends ConsumerState<PokemonDetailScreen> {
  late final TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    final nickname =
        ref.read(pokemonProvider).nicknames[widget.pokemonId] ?? '';
    _nicknameController = TextEditingController(text: nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonProvider);
    final pokemon = state.pokemon.firstWhere(
      (item) => item.id == widget.pokemonId,
    );
    final isFavorite = state.favoriteIds.contains(pokemon.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name.toUpperCase()),
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
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () =>
                ref.read(pokemonProvider.notifier).toggleFavorite(pokemon.id),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.network(
                pokemon.imageUrl,
                height: 220,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image_outlined, size: 96),
              ),
              const SizedBox(height: 20),
              Text(
                pokemon.name.toUpperCase(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Types: ${pokemon.types.join(', ').toUpperCase()}'),
              const SizedBox(height: 24),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      final nickname = _nicknameController.text.trim();
                      ref
                          .read(pokemonProvider.notifier)
                          .setNickname(pokemon.id, nickname);
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            nickname.isEmpty
                                ? 'Nickname removed.'
                                : 'Nickname saved.',
                          ),
                        ),
                      );
                    },
                    child: const Text('Save nickname'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      _nicknameController.clear();
                      ref
                          .read(pokemonProvider.notifier)
                          .removeNickname(pokemon.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nickname removed.')),
                      );
                    },
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFavorites(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => FavoritesPanel(
        onOpen: (id) {
          Navigator.pop(context);
          if (id != widget.pokemonId) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PokemonDetailScreen(pokemonId: id),
              ),
            );
          }
        },
      ),
    );
  }
}
