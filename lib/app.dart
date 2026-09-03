import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'theme/retrobyte_theme.dart';

class RetroByteApp extends StatefulWidget {
  const RetroByteApp({super.key});

  @override
  State<RetroByteApp> createState() => _RetroByteAppState();
}

class _RetroByteAppState extends State<RetroByteApp> {
  ThemeMode _themeMode = ThemeMode.light;

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen(
            isDarkMode: _themeMode == ThemeMode.dark,
            onToggleTheme: _toggleThemeMode,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'product/:id',
            name: 'details',
            builder: (BuildContext context, GoRouterState state) {
              final productId = state.pathParameters['id'] ?? 'unknown';
              return ProductDetailsScreen(productId: productId);
            },
          ),
        ],
      ),
    ],
  );

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RetroByte',
      themeMode: _themeMode,
      theme: RetroByteTheme.light(),
      darkTheme: RetroByteTheme.dark(),
      routerConfig: _router,
    );
  }
}