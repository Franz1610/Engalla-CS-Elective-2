import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/pokemon_list_screen.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isConfigured =
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  if (isConfigured) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }
  runApp(
    ProviderScope(
      child: PokedexApp(isConfigured: isConfigured),
    ),
  );
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({this.isConfigured = true, super.key});

  final bool isConfigured;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: isConfigured
          ? const PokemonListScreen()
          : const _ConfigurationScreen(),
    );
  }
}

class _ConfigurationScreen extends StatelessWidget {
  const _ConfigurationScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Supabase is not configured.\n\n'
            'Run with SUPABASE_URL and SUPABASE_ANON_KEY dart-defines.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
