import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/cart_state.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_confirmation_screen.dart';
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
  late final CartState _cartState = CartState();

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen(
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
          GoRoute(
            path: 'cart',
            name: 'cart',
            builder: (BuildContext context, GoRouterState state) {
              return const CartScreen();
            },
          ),
          GoRoute(
            path: 'checkout',
            name: 'checkout',
            builder: (BuildContext context, GoRouterState state) {
              return const CheckoutConfirmationScreen();
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
  void dispose() {
    _cartState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      cartState: _cartState,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'RetroByte',
        themeMode: _themeMode,
        theme: RetroByteTheme.light(),
        darkTheme: RetroByteTheme.dark(),
        routerConfig: _router,
      ),
    );
  }
}