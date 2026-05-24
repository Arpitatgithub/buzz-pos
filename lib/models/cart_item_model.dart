import 'product_model.dart';

class CartItemModel {

  final ProductModel product;
  final int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });

  double get total =>
      product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {

    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}