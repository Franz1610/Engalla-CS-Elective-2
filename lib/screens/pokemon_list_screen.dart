import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import 'pokemon_detail_screen.dart';
import '../widgets/pokemon_card.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        actions: [
          Consumer<PokemonProvider>(
            builder: (context, provider, child) {
              return IconButton(
                tooltip: 'Refresh Pokémon',
                onPressed: provider.isLoading ? null : provider.fetchPokemon,
                icon: const Icon(Icons.refresh),
              );
            },
          ),
        ],
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return _MessageState(
              icon: Icons.cloud_off_outlined,
              message: provider.errorMessage!,
              actionLabel: 'Try again',
              onAction: provider.fetchPokemon,
            );
          }

          if (provider.pokemon.isEmpty) {
            return const _MessageState(
              icon: Icons.catching_pokemon,
              message: 'No Pokémon found.',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: provider.pokemon.length,
            itemBuilder: (context, index) {
              final pokemon = provider.pokemon[index];
              return PokemonCard(
                pokemon: pokemon,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PokemonDetailScreen(pokemonId: pokemon.id),
                    ),
                  );
                },
              );
            },
          );
        },
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
