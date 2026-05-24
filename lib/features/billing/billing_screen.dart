import 'checkout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../products/product_provider.dart';
import 'cart_provider.dart';


class BillingScreen
    extends ConsumerWidget {

  const BillingScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final productState =
        ref.watch(productProvider);

    final cart =
        ref.watch(cartProvider);

    final cartNotifier =
        ref.read(
          cartProvider.notifier,
        );

    return Row(
      children: [

        // LEFT SIDE PRODUCTS
        Expanded(
          flex: 3,

          child: Container(
            padding:
                const EdgeInsets.all(20),

            child: productState.when(

              loading: () =>
                  const Center(
                    child:
                        CircularProgressIndicator(),
                  ),

              error: (e, _) =>
                  Center(
                    child: Text(
                      e.toString(),
                    ),
                  ),

              data: (products) {

                return GridView.builder(

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.4,
                  ),

                  itemCount: products.length,

                  itemBuilder:
                      (context, index) {

                    final product =
                        products[index];

                    return GestureDetector(

                      onTap: () {

                        cartNotifier
                            .addToCart(
                          product,
                        );
                      },

                      child: Container(

                        padding:
                            const EdgeInsets.all(
                          18,
                        ),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              product.name,

                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const Spacer(),

                            Text(
                              '₹ ${product.price}',

                              style:
                                  const TextStyle(
                                fontSize: 22,
                                color: Colors.blue,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              'Stock: ${product.stock}',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),

        // RIGHT SIDE CART
        Container(
          width: 420,

          padding:
              const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const Text(
                'Current Bill',

                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(

                child: cart.isEmpty

                    ? const Center(
                        child: Text(
                          'No Items Added',
                        ),
                      )

                    : ListView.builder(

                        itemCount:
                            cart.length,

                        itemBuilder:
                            (context, index) {

                          final item =
                              cart[index];

                          return Container(

                            margin:
                                const EdgeInsets.only(
                              bottom: 16,
                            ),

                            padding:
                                const EdgeInsets.all(
                              16,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.grey
                                      .shade100,

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  item.product.name,

                                  style:
                                      const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                Row(

                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,

                                  children: [

                                    Row(
                                      children: [

                                        IconButton(

                                          onPressed:
                                              () {

                                            cartNotifier
                                                .decreaseQuantity(
                                              item.product,
                                            );
                                          },

                                          icon:
                                              const Icon(
                                            Icons.remove_circle,
                                          ),
                                        ),

                                        Text(
                                          '${item.quantity}',
                                        ),

                                        IconButton(

                                          onPressed:
                                              () {

                                            cartNotifier
                                                .increaseQuantity(
                                              item.product,
                                            );
                                          },

                                          icon:
                                              const Icon(
                                            Icons.add_circle,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      '₹ ${item.total.toStringAsFixed(2)}',

                                      style:
                                          const TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),

              Container(

                padding:
                    const EdgeInsets.all(
                  20,
                ),

                decoration: BoxDecoration(

                  color:
                      Colors.blue.shade50,

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: Row(

                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

                    const Text(
                      'Total',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Text(
                      '₹ ${cartNotifier.totalAmount.toStringAsFixed(2)}',

                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.blue,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                height: 60,

                child: ElevatedButton(

                  onPressed: () {

  showDialog(
    context: context,

    builder: (_) =>
        CheckoutDialog(

  subtotal:
      cartNotifier.totalAmount,

  items: cart,
),
  );
},

                  child: const Text(
                    'Checkout',

                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}