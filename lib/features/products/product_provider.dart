import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product_model.dart';
import '../../services/product_service.dart';

final productProvider = StateNotifierProvider<
    ProductNotifier,
    AsyncValue<List<ProductModel>>>(
  (ref) => ProductNotifier(),
);

class ProductNotifier
    extends StateNotifier<
        AsyncValue<List<ProductModel>>> {

  final ProductService service =
      ProductService();

  ProductNotifier()
      : super(const AsyncLoading()) {

    loadProducts();
  }

  Future<void> loadProducts() async {

    try {

      final products =
          await service.fetchProducts();

      state = AsyncData(products);

    } catch (e, stack) {

      state = AsyncError(e, stack);
    }
  }

  Future<void> addProduct(
    ProductModel product,
  ) async {

    await service.addProduct(product);

    await loadProducts();
  }

  Future<void> deleteProduct(
    String id,
  ) async {

    await service.deleteProduct(id);

    await loadProducts();
  }

  Future<void> updateProduct(
    ProductModel product,
  ) async {

    await service.updateProduct(product);

    await loadProducts();
  }
}