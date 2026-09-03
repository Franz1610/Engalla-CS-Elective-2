import '../models/game_product.dart';

final List<GameProduct> sampleProducts = <GameProduct>[
  GameProduct(
    id: 'super-mario-64',
    name: 'Super Mario 64 Cartridge',
    platform: 'N64',
    condition: 'Mint',
    releaseYear: 1996,
    price: 559.99,
    imageAsset: 'assets/images/Supermario cartridges.jpg',
    description: 'A collector-grade classic from the first wave of 3D platformers.',
  ),
  GameProduct(
    id: 'kirby-dream-land',
    name: 'Kirby Dream Land Box Set',
    platform: 'SNES',
    condition: 'Used',
    releaseYear: 1994,
    price: 1274.50,
    imageAsset: 'assets/images/DreamlandSet.jpg',
    description: 'Bright, playful, and ready for any retro shelf display.',
  ),
  GameProduct(
    id: 'playstation-classic',
    name: 'PlayStation Classic Controller',
    platform: 'PS1',
    condition: 'Mint',
    releaseYear: 1997,
    price: 300.59,
    imageAsset: 'assets/images/Controller.jpg',
    description: 'An iconic first-gen controller with the original arcade feel.',
  ),
  GameProduct(
    id: 'zelda-ocarina',
    name: 'The Legend of Zelda: Ocarina of Time',
    platform: 'N64',
    condition: 'Used',
    releaseYear: 1998,
    price: 1340.50,
    imageAsset: 'assets/images/Legend of Zelda.jpg',
    description: 'A legendary adventure cartridge with strong display value.',
  ),
];