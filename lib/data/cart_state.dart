import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/game_product.dart';

class CartState extends ChangeNotifier {
  final List<CartItem> _items = <CartItem>[];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount {
    return _items.fold(0, (int total, CartItem item) => total + item.quantity);
  }

  double get totalPrice {
    return _items.fold(0.0, (double total, CartItem item) => total + item.subtotal);
  }

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  void addItem(GameProduct product, [int quantity = 1]) {
    final existingIndex = _items.indexWhere(
      (CartItem item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int delta) {
    final index = _items.indexWhere(
      (CartItem item) => item.product.id == productId,
    );
    if (index < 0) return;

    final newQty = _items[index].quantity + delta;
    if (newQty <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = newQty;
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((CartItem item) => item.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class CartScope extends InheritedNotifier<CartState> {
  const CartScope({
    super.key,
    required CartState cartState,
    required super.child,
  }) : super(notifier: cartState);

  static CartState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'No CartScope found in context');
    return scope!.notifier!;
  }
}
