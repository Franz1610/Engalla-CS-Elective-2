import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../services/product_service.dart';

const productsPerPage = 8;
const minimumProductPrice = 0.0;
const maximumProductPrice = 1000.0;

class ProductState {
  const ProductState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.notes = const {},
    this.savedIds = const {},
    this.isSavedPanelExpanded = false,
    this.page = 0,
    this.totalCount = 0,
    this.minimumPrice = minimumProductPrice,
    this.maximumPrice = maximumProductPrice,
  });

  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;
  final Map<int, String> notes;
  final Set<int> savedIds;
  final bool isSavedPanelExpanded;
  final int page;
  final int totalCount;
  final double minimumPrice;
  final double maximumPrice;

  bool get canGoPrevious => page > 0;
  bool get canGoNext => (page + 1) * productsPerPage < totalCount;

  List<Product> get savedProducts =>
      products.where((item) => savedIds.contains(item.id)).toList();

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    Map<int, String>? notes,
    Set<int>? savedIds,
    bool? isSavedPanelExpanded,
    int? page,
    int? totalCount,
    double? minimumPrice,
    double? maximumPrice,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      notes: notes ?? this.notes,
      savedIds: savedIds ?? this.savedIds,
      isSavedPanelExpanded: isSavedPanelExpanded ?? this.isSavedPanelExpanded,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      maximumPrice: maximumPrice ?? this.maximumPrice,
    );
  }
}

final productProvider = NotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<ProductState> {
  ProductNotifier({this._service});

  ProductService? _service;

  ProductService get service => _service ??= ProductService();

  @override
  ProductState build() {
    ref.onDispose(() => _service?.dispose());
    return const ProductState();
  }

  Future<void> fetchProducts({int? page}) async {
    final requestedPage = page ?? state.page;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await service.fetchProducts(
        minimumPrice: state.minimumPrice,
        maximumPrice: state.maximumPrice,
        page: requestedPage,
        pageSize: productsPerPage,
      );
      state = state.copyWith(
        products: result.products,
        totalCount: result.totalCount,
        page: requestedPage,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load products.\n$error',
      );
    }
  }

  Future<void> setPriceRange(double start, double end) async {
    state = state.copyWith(minimumPrice: start, maximumPrice: end, page: 0);
    await fetchProducts(page: 0);
  }

  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required int categoryId,
    String? imageUrl,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await service.createProduct(
        name: name,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      await fetchProducts(page: 0);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to add product.\n$error',
      );
      return false;
    }
  }

  Future<bool> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int stock,
    required int categoryId,
    String? imageUrl,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await service.updateProduct(
        id: id,
        name: name,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      await fetchProducts(page: state.page);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to update product.\n$error',
      );
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await service.deleteProduct(id);
      final nextPage = state.products.length == 1 && state.page > 0
          ? state.page - 1
          : state.page;
      await fetchProducts(page: nextPage);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to delete product.\n$error',
      );
      return false;
    }
  }

  Future<void> goToPage(int page) {
    if (page < 0 || (!state.canGoNext && page > state.page)) {
      return Future.value();
    }
    return fetchProducts(page: page);
  }

  void setNote(int productId, String note) {
    final updated = {...state.notes};
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      updated.remove(productId);
    } else {
      updated[productId] = trimmed;
    }
    state = state.copyWith(notes: updated);
  }

  void removeNote(int productId) {
    state = state.copyWith(notes: {...state.notes}..remove(productId));
  }

  void toggleSaved(int productId) {
    final updated = {...state.savedIds};
    if (!updated.add(productId)) {
      updated.remove(productId);
    }
    state = state.copyWith(savedIds: updated);
  }

  void toggleSavedPanel() {
    state = state.copyWith(isSavedPanelExpanded: !state.isSavedPanelExpanded);
  }
}
