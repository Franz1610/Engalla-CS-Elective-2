import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/favorites_panel.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productProvider.notifier).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);
    final notifier = ref.read(productProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Saved products',
            onPressed: () => _showSavedProducts(context),
            icon: Badge(
              label: Text('${state.savedProducts.length}'),
              isLabelVisible: state.savedProducts.isNotEmpty,
              child: const Icon(Icons.favorite_border),
            ),
          ),
          IconButton(
            tooltip: 'Refresh products',
            onPressed: state.isLoading ? null : notifier.fetchProducts,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Supabase.instance.client.auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ProductFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
      body: RefreshIndicator(
        onRefresh: notifier.fetchProducts,
        child: Column(
          children: [
            _PriceFilter(state: state),
            Expanded(child: _buildBody(context, state)),
            _PaginationControls(state: state, onPageChanged: notifier.goToPage),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: _MessageState(
              icon: Icons.cloud_off_outlined,
              message: state.errorMessage!,
              actionLabel: 'Try again',
              onAction: ref.read(productProvider.notifier).fetchProducts,
            ),
          ),
        ],
      );
    }

    if (state.products.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: const _MessageState(
              icon: Icons.storefront_outlined,
              message: 'No products found.',
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = state.products[index];
              return ProductCard(
                product: product,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ProductDetailScreen(productId: product.id),
                  ),
                ),
              );
            }, childCount: state.products.length),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
          ),
        ),
      ],
    );
  }

  void _showSavedProducts(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => FavoritesPanel(
        onOpen: (id) {
          Navigator.pop(context);
          Navigator.of(this.context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProductDetailScreen(productId: id),
            ),
          );
        },
      ),
    );
  }
}

class _PriceFilter extends ConsumerWidget {
  const _PriceFilter({required this.state});

  final ProductState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Price: \$${state.minimumPrice.toStringAsFixed(0)} - '
                '\$${state.maximumPrice.toStringAsFixed(0)}',
              ),
            ),
            RangeSlider(
              values: RangeValues(state.minimumPrice, state.maximumPrice),
              min: minimumProductPrice,
              max: maximumProductPrice,
              divisions: 100,
              labels: RangeLabels(
                '\$${state.minimumPrice.toStringAsFixed(0)}',
                '\$${state.maximumPrice.toStringAsFixed(0)}',
              ),
              onChanged: state.isLoading
                  ? null
                  : (values) => ref
                        .read(productProvider.notifier)
                        .setPriceRange(values.start, values.end),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({required this.state, required this.onPageChanged});

  final ProductState state;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final pageCount = state.totalCount == 0
        ? 0
        : (state.totalCount + productsPerPage - 1) ~/ productsPerPage;
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: 'Previous page',
            onPressed: state.isLoading || !state.canGoPrevious
                ? null
                : () => onPageChanged(state.page - 1),
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            pageCount == 0
                ? 'No pages'
                : 'Page ${state.page + 1} of $pageCount',
          ),
          IconButton(
            tooltip: 'Next page',
            onPressed: state.isLoading || !state.canGoNext
                ? null
                : () => onPageChanged(state.page + 1),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
