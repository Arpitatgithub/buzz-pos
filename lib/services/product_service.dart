import '../core/supabase_client.dart';
import '../models/product_model.dart';

class ProductService {
  Future<void> updateProduct(
  ProductModel product,
) async {

  await supabase
      .from('products')
      .update(product.toMap())
      .eq('id', product.id);
}

  Future<List<ProductModel>>
      fetchProducts() async {

    final response =
        await supabase
            .from('products')
            .select();

    return response
        .map<ProductModel>(
          (product) =>
              ProductModel.fromMap(product),
        )
        .toList();
  }

  Future<void> addProduct(
    ProductModel product,
  ) async {

    await supabase
        .from('products')
        .insert(product.toMap());
  }

  Future<void> deleteProduct(
    String id,
  ) async {

    await supabase
        .from('products')
        .delete()
        .eq('id', id);
  }
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