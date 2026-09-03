import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const RetroByteApp());
}

class RetroByteApp extends StatefulWidget {
  const RetroByteApp({super.key});

  @override
  State<RetroByteApp> createState() => _RetroByteAppState();
}

class _RetroByteAppState extends State<RetroByteApp> {
  ThemeMode _themeMode = ThemeMode.light;

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen(
            isDarkMode: _themeMode == ThemeMode.dark,
            onToggleTheme: _toggleThemeMode,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'product/:id',
            name: 'details',
            builder: (BuildContext context, GoRouterState state) {
              final productId = state.pathParameters['id'] ?? 'unknown';
              return ProductDetailsScreen(productId: productId);
            },
          ),
        ],
      ),
    ],
  );

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RetroByte',
      themeMode: _themeMode,
      theme: RetroByteTheme.light(),
      darkTheme: RetroByteTheme.dark(),
      routerConfig: _router,
    );
  }
}

class RetroByteTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2D6BFF),
      brightness: Brightness.light,
      primary: const Color(0xFF1F4DFF),
      secondary: const Color(0xFFFF4FB3),
      surface: const Color(0xFFF6F7FB),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF10131A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF28E0F7),
      brightness: Brightness.dark,
      primary: const Color(0xFF28E0F7),
      secondary: const Color(0xFFFF4FD8),
      surface: const Color(0xFF11131A),
      onPrimary: const Color(0xFF071018),
      onSecondary: const Color(0xFF071018),
      onSurface: const Color(0xFFF3F5FF),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF07080C),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  int _crossAxisCountForWidth(double width) {
    if (width >= 1000) {
      return 4;
    }
    if (width >= 700) {
      return 3;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RetroByte'),
        actions: <Widget>[
          IconButton(
            onPressed: onToggleTheme,
            tooltip: 'Toggle theme',
            icon: Icon(isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final crossAxisCount = _crossAxisCountForWidth(constraints.maxWidth);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sampleProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: crossAxisCount >= 3 ? 0.78 : 0.72,
            ),
            itemBuilder: (BuildContext context, int index) {
              final product = sampleProducts[index];
              return ProductCard(
                product: product,
                onTap: () => context.go('/product/${product.id}'),
                accentColor: colorScheme.primary,
              );
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.accentColor,
  });

  final GameProduct product;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        product.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return ColoredBox(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.transparent,
                              colorScheme.shadow.withValues(alpha: 0.35),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'PHP ${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: accentColor,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                '${product.platform} | ${product.condition} | ${product.releaseYear}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = sampleProducts.firstWhere(
      (GameProduct item) => item.id == productId,
      orElse: () => sampleProducts.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Product details go here.',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This checkpoint only needs routing in place. The full product detail, cart, and checkout flow will be added next.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Text('Selected item: ${product.name}'),
                    Text('Platform: ${product.platform}'),
                    Text('Release year: ${product.releaseYear}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
