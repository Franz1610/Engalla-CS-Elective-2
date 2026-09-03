import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/sample_products.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  int _crossAxisCountForWidth(double width) {
    if (width >= 1000) {
      return 4;
    }
    if (width >= 700) {
      return 3;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RetroByte'),
        actions: <Widget>[
          IconButton(
            onPressed: onToggleTheme,
            tooltip: 'Toggle theme',
            icon: Icon(isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final crossAxisCount = _crossAxisCountForWidth(constraints.maxWidth);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sampleProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: crossAxisCount >= 3 ? 0.78 : 0.72,
            ),
            itemBuilder: (BuildContext context, int index) {
              final product = sampleProducts[index];
              return ProductCard(
                product: product,
                onTap: () => context.go('/product/${product.id}'),
                accentColor: colorScheme.primary,
              );
            },
          );
        },
      ),
    );
  }
}