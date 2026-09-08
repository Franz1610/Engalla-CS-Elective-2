import 'game_product.dart';

class CartItem {
  CartItem({
    required this.product,
    this.quantity = 1,
  });

  final GameProduct product;
  int quantity;

  double get subtotal => product.price * quantity;
}
