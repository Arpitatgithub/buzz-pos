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

  // =====================================================
  // LOAD PRODUCTS
  // =====================================================

  Future<void> loadProducts() async {
    try {
      final products =
          await service.fetchProducts();

      state = AsyncData(products);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  // =====================================================
  // ADD PRODUCT
  // =====================================================

  Future<void> addProduct(
    ProductModel product,
  ) async {
    await service.addProduct(product);

    await loadProducts();
  }

  // =====================================================
  // UPDATE PRODUCT
  // =====================================================

  Future<void> updateProduct(
    ProductModel product,
  ) async {
    await service.updateProduct(product);

    await loadProducts();
  }

  // =====================================================
  // DELETE PRODUCT
  // =====================================================

  Future<void> deleteProduct(
    String id,
  ) async {
    await service.deleteProduct(id);

    await loadProducts();
  }

  // =====================================================
  // MANUAL STOCK ADJUSTMENT
  // =====================================================

  Future<int> adjustStock({
    required String productId,
    required int quantityChange,
    required String reason,
  }) async {
    final newStock =
        await service.adjustStock(
      productId: productId,
      quantityChange:
          quantityChange,
      reason: reason,
    );

    // Refresh immediately so the
    // Products screen shows the
    // new stock without restarting.
    await loadProducts();

    return newStock;
  }

  // =====================================================
  // DECREASE STOCK
  // =====================================================

  Future<void> decreaseStock({
    required String productId,
    required int quantity,
  }) async {
    await service.decreaseStock(
      productId: productId,
      quantity: quantity,
    );

    await loadProducts();
  }
}