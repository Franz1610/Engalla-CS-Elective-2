class Pokemon {
  const Pokemon({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.types,
    required this.price,
  });

  final String name;
  final int id;
  final String imageUrl;
  final List<String> types;
  final double price;

  factory Pokemon.fromJson(Map<String, dynamic> json, {List<String>? types}) {
    final name = json['name'] as String;
    final url = json['url'] as String;
    final id = int.parse(url.split('/').where((part) => part.isNotEmpty).last);

    return Pokemon(
      name: name,
      id: id,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
      types: types ?? const [],
      price: 0,
    );
  }

  factory Pokemon.fromProductMap(Map<String, dynamic> map) {
    final id = map['id'];
    final name = map['name'];
    final price = map['price'];
    if (id is! num || name is! String || price is! num) {
      throw const FormatException('Invalid product returned by Supabase.');
    }

    final imageUrl = map['image_url'] as String?;
    return Pokemon(
      id: id.toInt(),
      name: name,
      imageUrl: imageUrl ?? '',
      types: (map['types'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      price: price.toDouble(),
    );
  }
}
