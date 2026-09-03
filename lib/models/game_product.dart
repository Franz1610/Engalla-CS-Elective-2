class GameProduct {
  const GameProduct({
    required this.id,
    required this.name,
    required this.platform,
    required this.condition,
    required this.releaseYear,
    required this.price,
    required this.imageAsset,
    required this.description,
  });

  final String id;
  final String name;
  final String platform;
  final String condition;
  final int releaseYear;
  final double price;
  final String imageAsset;
  final String description;
}