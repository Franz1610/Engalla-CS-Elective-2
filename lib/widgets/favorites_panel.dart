import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_provider.dart';

class FavoritesPanel extends ConsumerWidget {
  const FavoritesPanel({required this.onOpen, super.key});

  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);
    final notifier = ref.read(productProvider.notifier);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Saved products'),
            trailing: IconButton(
              onPressed: notifier.toggleSavedPanel,
              icon: Icon(
                state.isSavedPanelExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
              ),
            ),
          ),
          if (state.isSavedPanelExpanded)
            if (state.savedProducts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No products have been saved yet.'),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ...state.savedProducts.map(
                      (product) => ListTile(
                        leading: product.imageUrl == null
                            ? const Icon(Icons.shopping_bag_outlined)
                            : Image.network(product.imageUrl!, width: 48),
                        title: Text(product.name),
                        subtitle: Text(state.notes[product.id] ?? ''),
                        onTap: () => onOpen(product.id),
                        trailing: IconButton(
                          onPressed: () => notifier.toggleSaved(product.id),
                          icon: const Icon(Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
