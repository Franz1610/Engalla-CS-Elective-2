import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product.dart';

class ProductPage {
  const ProductPage({required this.products, required this.totalCount});

  final List<Product> products;
  final int totalCount;
}

class ProductService {
  ProductService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<ProductPage> fetchProducts({
    required double minimumPrice,
    required double maximumPrice,
    required int page,
    int pageSize = 8,
  }) async {
    final start = page * pageSize;
    final end = start + pageSize - 1;
    final rows = await _client
        .from('products')
        .select('*')
        .gte('price', minimumPrice)
        .lte('price', maximumPrice)
        .order('created_at', ascending: false)
        .range(start, end);
    final countResponse = await _client
        .from('products')
        .select('*')
        .gte('price', minimumPrice)
        .lte('price', maximumPrice)
        .count(CountOption.exact);

    return ProductPage(
      products: rows.map(Product.fromMap).toList(),
      totalCount: countResponse.count,
    );
  }

  void dispose() {}
}
