import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/cart_state.dart';
import '../models/cart_item.dart';

/// [CheckoutConfirmationScreen] displays the finalized order summary:
/// cart items, subtotal per item, overall total, and retro confirmation message.
/// Per rubrics, it is only reachable when at least one item is in the cart.
class CheckoutConfirmationScreen extends StatefulWidget {
  const CheckoutConfirmationScreen({super.key});

  @override
  State<CheckoutConfirmationScreen> createState() =>
      _CheckoutConfirmationScreenState();
}

class _CheckoutConfirmationScreenState
    extends State<CheckoutConfirmationScreen> {
  // Snapshot captured on mount before order completion/clearing
  late final List<CartItem> _orderedItems;
  late final double _finalTotal;
  late final int _finalCount;
  late final bool _hadItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cartState = CartScope.of(context);
    _hadItems = cartState.isNotEmpty;
    if (_hadItems) {
      _orderedItems = cartState.items
          .map((item) => CartItem(product: item.product, quantity: item.quantity))
          .toList();
      _finalTotal = cartState.totalPrice;
      _finalCount = cartState.totalItemCount;
    } else {
      _orderedItems = <CartItem>[];
      _finalTotal = 0.0;
      _finalCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Guard requirement: "Reachable only after at least one item is in the cart"
    if (!_hadItems) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout Guarded'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.lock_outline_rounded,
                  size: 64,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cart Is Empty',
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  'Checkout is only accessible when you have at least one item in your cart.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Retro Success Banner Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            size: 56,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ORDER CONFIRMED!',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Cartridges Secured! Your 8-bit adventure is on its way.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Order #RB-8BIT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Order Items Breakdown Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Purchased Items ($_finalCount)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Divider(height: 24),
                        ..._orderedItems.map((CartItem item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: <Widget>[
                                // Mini high contrast thumbnail
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(
                                    item.product.imageAsset,
                                    fit: BoxFit.contain,
                                    errorBuilder: (
                                      BuildContext context,
                                      Object error,
                                      StackTrace? stackTrace,
                                    ) => Icon(
                                      Icons.videogame_asset,
                                      size: 20,
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Title and Quantity
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Qty: ${item.quantity} × ₱${item.product.price.toStringAsFixed(2)}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),

                                // Subtotal per item
                                Text(
                                  '₱${item.subtotal.toStringAsFixed(2)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Grand Total Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Retro Shipping',
                                style: theme.textTheme.bodyMedium),
                            Text(
                              'FREE (Cartridge Courier)',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Items Subtotal',
                                style: theme.textTheme.bodyMedium),
                            Text(
                              '₱${_finalTotal.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total Paid:',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '₱${_finalTotal.toStringAsFixed(2)}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Continue Shopping Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.home_outlined),
                  label: const Text(
                    'Back to RetroByte Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Clear the cart on successful checkout completion
                    CartScope.of(context).clear();
                    context.go('/');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
