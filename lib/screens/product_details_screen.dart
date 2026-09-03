import 'package:flutter/material.dart';

import '../data/sample_products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = sampleProducts.firstWhere(
      (item) => item.id == productId,
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