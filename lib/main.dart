import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/pokemon_provider.dart';
import 'screens/pokemon_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonProvider()..fetchPokemon(),
      child: const PokedexApp(),
    ),
  );
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokemonListScreen(),
    );
  }
}
