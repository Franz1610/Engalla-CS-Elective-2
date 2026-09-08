import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/cart_state.dart';

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = CartScope.of(context);
    final count = cartState.totalItemCount;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          tooltip: 'View Cart',
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => context.push('/cart'),
        ),
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).appBarTheme.backgroundColor ?? colorScheme.surface,
                  width: 1.5,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: TextStyle(
                  color: colorScheme.onSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
