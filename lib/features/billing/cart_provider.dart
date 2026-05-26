import '../../models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cart_item_model.dart';

final cartProvider = StateNotifierProvider<
    CartNotifier,
    List<CartItemModel>>(
  (ref) => CartNotifier(),
);

class CartNotifier
    extends StateNotifier<
        List<CartItemModel>> {

  CartNotifier() : super([]);

  void addToCart(
    ProductModel product,
  ) {

    final index = state.indexWhere(
      (item) =>
          item.product.id == product.id,
    );

    if (index >= 0) {

      state[index] = state[index]
          .copyWith(
        quantity:
            state[index].quantity + 1,
      );

      state = [...state];

    } else {

      state = [

        ...state,

        CartItemModel(
          product: product,
          quantity: 1,
        ),
      ];
    }
  }

  void increaseQuantity(
    ProductModel product,
  ) {

    final index = state.indexWhere(
      (item) =>
          item.product.id == product.id,
    );

    if (index >= 0) {

      state[index] = state[index]
          .copyWith(
        quantity:
            state[index].quantity + 1,
      );

      state = [...state];
    }
  }

  void decreaseQuantity(
    ProductModel product,
  ) {

    final index = state.indexWhere(
      (item) =>
          item.product.id == product.id,
    );

    if (index >= 0) {

      final item = state[index];

      if (item.quantity == 1) {

        removeItem(product);

      } else {

        state[index] =
            item.copyWith(
          quantity:
              item.quantity - 1,
        );

        state = [...state];
      }
    }
  }

  void removeItem(
    ProductModel product,
  ) {

    state = state
        .where(
          (item) =>
              item.product.id !=
              product.id,
        )
        .toList();
  }

  double get totalAmount {

    return state.fold(
      0,
      (sum, item) =>
          sum + item.total,
    );
  }
void removeFromCart(
  ProductModel product,
) {

  state = state.where(

    (item) =>
        item.product.id !=
        product.id,

  ).toList();
}
  void clearCart() {
    state = [];
  }
}