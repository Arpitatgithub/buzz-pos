import '../core/supabase_client.dart';
import '../models/product_model.dart';

class ProductService {
  // =====================================================
  // FETCH PRODUCTS
  // =====================================================

  Future<List<ProductModel>> fetchProducts() async {
    final response = await supabase
        .from('products')
        .select();

    return response
        .map<ProductModel>(
          (product) =>
              ProductModel.fromMap(product),
        )
        .toList();
  }

  // =====================================================
  // ADD PRODUCT
  // =====================================================

  Future<void> addProduct(
    ProductModel product,
  ) async {
    final data = product.toMap();

    await supabase.rpc(
      'create_product',
      params: {
        'p_id': product.id,
        'p_name': product.name,
        'p_barcode': product.barcode,
        'p_price': product.price,
        'p_stock': product.stock,
        'p_category': product.category,
        'p_image_url':
            data['image_url'] ?? '',
      },
    );
  }

  // =====================================================
  // UPDATE PRODUCT
  // =====================================================

  Future<void> updateProduct(
    ProductModel product,
  ) async {
    final data = product.toMap();

    await supabase.rpc(
      'update_product',
      params: {
        'p_id': product.id,
        'p_name': product.name,
        'p_barcode': product.barcode,
        'p_price': product.price,
        'p_stock': product.stock,
        'p_category': product.category,
        'p_image_url':
            data['image_url'] ?? '',
      },
    );
  }

  // =====================================================
  // DELETE PRODUCT
  // =====================================================

  Future<void> deleteProduct(
    String id,
  ) async {
    await supabase.rpc(
      'delete_product',
      params: {
        'p_id': id,
      },
    );
  }

  // =====================================================
  // MANUAL STOCK ADJUSTMENT
  // =====================================================

  Future<int> adjustStock({
    required String productId,
    required int quantityChange,
    required String reason,
  }) async {
    final response = await supabase.rpc(
      'adjust_product_stock',
      params: {
        'p_product_id': productId,
        'p_quantity_change': quantityChange,
        'p_reason': reason,
      },
    );

    return (response as num).toInt();
  }

  // =====================================================
  // DECREASE STOCK
  // =====================================================

  Future<void> decreaseStock({
    required String productId,
    required int quantity,
  }) async {
    await supabase.rpc(
      'decrease_product_stock',
      params: {
        'p_product_id': productId,
        'p_quantity': quantity,
      },
    );
  }
}