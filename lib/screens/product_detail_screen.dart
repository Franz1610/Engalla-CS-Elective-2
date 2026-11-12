import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/favorites_panel.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final int productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final note = ref.read(productProvider).notes[widget.productId] ?? '';
    _noteController = TextEditingController(text: note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    final matchingProducts = state.products.where(
      (item) => item.id == widget.productId,
    );
    if (matchingProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: Center(
          child: state.isLoading
              ? const CircularProgressIndicator()
              : Text(state.errorMessage ?? 'Product is no longer available.'),
        ),
      );
    }
    final product = matchingProducts.first;
    final isSaved = state.savedIds.contains(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => _showSavedProducts(context),
            icon: Badge(
              label: Text('${state.savedProducts.length}'),
              isLabelVisible: state.savedProducts.isNotEmpty,
              child: const Icon(Icons.bookmark_border),
            ),
          ),
          IconButton(
            tooltip: isSaved ? 'Remove from saved products' : 'Save product',
            onPressed: () =>
                ref.read(productProvider.notifier).toggleSaved(product.id),
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? Colors.red : null,
            ),
          ),
          IconButton(
            tooltip: 'Edit product',
            onPressed: () => _editProduct(product),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete product',
            onPressed: () => _confirmDelete(product.id),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.network(
                product.imageUrl ?? '',
                height: 220,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image_outlined, size: 96),
              ),
              const SizedBox(height: 20),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Product #${product.id}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Category ID: ${product.categoryId}'),
              const SizedBox(height: 8),
              Text('Stock: ${product.stock}'),
              if (product.description != null) ...[
                const SizedBox(height: 8),
                Text(product.description!),
              ],
              const SizedBox(height: 8),
              Text(
                'Price: \$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Personal note',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      final note = _noteController.text.trim();
                      ref
                          .read(productProvider.notifier)
                          .setNote(product.id, note);
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            note.isEmpty ? 'Note removed.' : 'Note saved.',
                          ),
                        ),
                      );
                    },
                    child: const Text('Save note'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      _noteController.clear();
                      ref.read(productProvider.notifier).removeNote(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note removed.')),
                      );
                    },
                    child: const Text('Remove note'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editProduct(Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductFormScreen(product: product),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _confirmDelete(int productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final success = await ref
        .read(productProvider.notifier)
        .deleteProduct(productId);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      final error = ref.read(productProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Unable to delete product.')),
      );
    }
  }

  void _showSavedProducts(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => FavoritesPanel(
        onOpen: (id) {
          Navigator.pop(context);
          if (id != widget.productId) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ProductDetailScreen(productId: id),
              ),
            );
          }
        },
      ),
    );
  }
}
