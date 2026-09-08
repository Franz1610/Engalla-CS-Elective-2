import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/sample_products.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_card.dart';

/// [HomeScreen] is a [StatelessWidget] because its catalog presentation
/// is immutable once built. Dynamic adaptations (theme switching, responsiveness)
/// are handled declaratively via [Theme.of] and [LayoutBuilder].
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onToggleTheme,
  });

  final VoidCallback onToggleTheme;

  int _crossAxisCountForWidth(double width) {
    if (width >= 1000) {
      return 4;
    }
    if (width >= 650) {
      return 3;
    }
    return 2;
  }

  double _childAspectRatioForWidth(double width) {
    if (width >= 1000) {
      return 0.85;
    }
    if (width >= 650) {
      return 0.80;
    }
    return 0.75;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RetroByte',
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontFamily: 'monospace',
            letterSpacing: 1.5,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: onToggleTheme,
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
            ),
          ),
          const CartBadgeButton(),
          const SizedBox(width: 4),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final crossAxisCount = _crossAxisCountForWidth(constraints.maxWidth);
          final aspectRatio = _childAspectRatioForWidth(constraints.maxWidth);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sampleProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (BuildContext context, int index) {
              final product = sampleProducts[index];
              return ProductCard(
                product: product,
                onTap: () => context.push('/product/${product.id}'),
              );
            },
          );
        },
      ),
    );
  }
}