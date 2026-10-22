class Pokemon {
  const Pokemon({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.types,
  });

  final String name;
  final int id;
  final String imageUrl;
  final List<String> types;

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
    );
  }
}
