class Product {
  const Product({
    required this.name,
    required this.id,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.imageUrl,
  });

  final String name;
  final int id;
  final String? description;
  final double price;
  final int stock;
  final int categoryId;
  final String? imageUrl;

  factory Product.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final name = map['name'];
    final price = map['price'];
    if (id is! num || name is! String || price is! num) {
      throw const FormatException('Invalid product returned by Supabase.');
    }

    final rawStock = map['stock'];
    final rawCategoryId = map['category_id'];
    if (rawStock is! num || rawCategoryId is! num) {
      throw const FormatException('Product is missing stock or category_id.');
    }
    return Product(
      id: id.toInt(),
      name: name,
      description: map['description'] as String?,
      price: price.toDouble(),
      stock: rawStock.toInt(),
      categoryId: rawCategoryId.toInt(),
      imageUrl: map['image_url'] as String?,
    );
  }
}
