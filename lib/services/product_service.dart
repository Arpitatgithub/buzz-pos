import '../core/supabase_client.dart';
import '../models/product_model.dart';

class ProductService {

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
}