import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({required this.pokemonId, super.key});

  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    final pokemon = context.read<PokemonProvider>().pokemon.firstWhere(
      (item) => item.id == pokemonId,
    );

    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name.toUpperCase())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              pokemon.imageUrl,
              height: 220,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image_outlined, size: 96);
              },
            ),
            const SizedBox(height: 20),
            Text(
              pokemon.name.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}