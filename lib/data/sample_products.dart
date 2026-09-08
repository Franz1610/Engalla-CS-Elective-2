import '../models/game_product.dart';

final List<GameProduct> sampleProducts = <GameProduct>[
  const GameProduct(
    id: 'zelda-ocarina',
    name: 'Zelda Ocarina of Time',
    platform: 'N64',
    condition: 'Very Good',
    releaseYear: 1998,
    price: 2800.00,
    imageAsset: 'assets/images/Legend of Zelda.jpg',
    description:
        'A legendary gold cartridge release for Nintendo 64. Features the complete epic quest across Hyrule, pristine save battery, and iconic box art heritage.',
  ),
  const GameProduct(
    id: 'ps1-console',
    name: 'PlayStation 1 Console',
    platform: 'PS1',
    condition: 'Refurbished',
    releaseYear: 1995,
    price: 4200.00,
    imageAsset: 'assets/images/Controller.jpg',
    description:
        'Original classic Sony PlayStation package with matching grey digital controller, AV composite cables, and official power brick. Tested and optical lens tuned.',
  ),
  const GameProduct(
    id: 'super-mario-world',
    name: 'Super Mario World',
    platform: 'SNES',
    condition: 'Mint',
    releaseYear: 1990,
    price: 1850.00,
    imageAsset: 'assets/images/Supermario cartridges.jpg',
    description:
        'The definitive 16-bit platformer that introduced Yoshi to the world. Pristine cartridge label with bright color and clean gold connector pins.',
  ),
  const GameProduct(
    id: 'kirby-dream-land',
    name: 'Kirby Dream Land Box Set',
    platform: 'SNES',
    condition: 'Used',
    releaseYear: 1994,
    price: 2950.00,
    imageAsset: 'assets/images/DreamlandSet.jpg',
    description:
        'A colorful and nostalgic SNES favorite featuring Kirby’s classic puff-and-inhale action. Complete with dust sleeve and tested playable.',
  ),
  const GameProduct(
    id: 'n64-controller',
    name: 'N64 Controller',
    platform: 'N64',
    condition: 'Used - Good',
    releaseYear: 1996,
    price: 1450.00,
    imageAsset: 'assets/images/N64 Controller.jpg',
    description:
        'Iconic trident three-handle Nintendo 64 controller in classic charcoal grey with responsive analog stick, Z-trigger, and tight button feel.',
  ),
  const GameProduct(
    id: 'sega-genesis',
    name: 'Sega Genesis Controller',
    platform: 'Genesis',
    condition: 'Used',
    releaseYear: 1993,
    price: 950.00,
    imageAsset: 'assets/images/SEGA controller.jpg',
    description:
        'Original ergonomic 3-button control pad for Sega Genesis. Built for lightning-fast blast processing arcade action with responsive D-pad.',
  ),
  const GameProduct(
    id: 'metroid-nes',
    name: 'Metroid NES Cart',
    platform: 'NES',
    condition: 'Good',
    releaseYear: 1986,
    price: 1650.00,
    imageAsset: 'assets/images/Metroid.jpg',
    description:
        'Explore Planet Zebes in the seminal sci-fi classic that established the Metroidvania genre. Authentic grey NES cartridge, cleaned and verified.',
  ),
  const GameProduct(
    id: 'pokemon-red',
    name: 'Pokémon Red Version',
    platform: 'Game Boy',
    condition: 'Mint',
    releaseYear: 1996,
    price: 2450.00,
    imageAsset: 'assets/images/Pokemon red.jpg',
    description:
        'The iconic monster-catching adventure that started it all. Authentic Game Boy cartridge with vivid label art and tested battery save function.',
  ),
];