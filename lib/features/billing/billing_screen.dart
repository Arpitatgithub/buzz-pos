import 'checkout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../products/product_provider.dart';
import 'cart_provider.dart';

class BillingScreen
    extends ConsumerStatefulWidget {

  const BillingScreen({
    super.key,
  });

  @override
  ConsumerState<BillingScreen>
      createState() =>
          _BillingScreenState();
}

class _BillingScreenState
    extends ConsumerState<BillingScreen> {

  String search = '';
  List<String> categories = [];
  String selectedCategory = 'All';

  @override
  Widget build(
    BuildContext context,
  ) {

    final productState =
        ref.watch(productProvider);

    final cart =
        ref.watch(cartProvider);

    final cartNotifier =
        ref.read(
          cartProvider.notifier,
        );

    return Padding(

      padding:
          const EdgeInsets.all(20),

      child: Row(

        children: [

          // LEFT SIDE
          Expanded(
            flex: 3,

            child: Column(

              children: [

                // SEARCH BAR
                Container(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: TextField(

                    decoration:
                        const InputDecoration(

                      border:
                          InputBorder.none,

                      hintText:
                          'Search products...',

                      icon: Icon(
                        Icons.search,
                      ),
                    ),

                    onChanged: (value) {

                      setState(() {

                        search =
                            value.toLowerCase();
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(

  height: 50,

  child: ListView.separated(

    scrollDirection:
        Axis.horizontal,

    itemCount:
        categories.length,

    separatorBuilder:
        (_, __) =>
            const SizedBox(
      width: 12,
    ),

    itemBuilder:
        (context, index) {

      final category =
          categories[index];

      final isSelected =
          selectedCategory ==
              category;

      return GestureDetector(

        onTap: () {

          setState(() {

            selectedCategory =
                category;
          });
        },

        child: AnimatedContainer(

          duration:
              const Duration(
            milliseconds: 200,
          ),

          padding:
              const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 12,
          ),

          decoration:
              BoxDecoration(

            color: isSelected
                ? Colors.blue
                : Colors.white,

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),

          child: Text(

            category,

            style: TextStyle(

              color: isSelected
                  ? Colors.white
                  : Colors.black,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      );
    },
  ),
),

                // PRODUCTS GRID
                Expanded(

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

  categories = [

    'All',

    ...products
        .map(
          (p) => p.category,
        )
        .toSet(),
  ];

  final filteredProducts =
      products.where((p) {

    final matchesSearch =
        p.name
            .toLowerCase()
            .contains(search);

    final matchesCategory =
        selectedCategory == 'All'
            ? true
            : p.category ==
                selectedCategory;

    return matchesSearch &&
        matchesCategory;

  }).toList();

                      return LayoutBuilder(

  builder: (context, constraints) {

    final width =
        constraints.maxWidth;

    final crossAxisCount =
        width > 1400
            ? 4
            : width > 1100
                ? 3
                : width > 700
                    ? 2
                    : 1;

    return GridView.builder(

      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount:
            crossAxisCount,

        crossAxisSpacing: 20,

        mainAxisSpacing: 20,

        childAspectRatio:
    width > 1400
        ? 1.2
        : width > 1100
            ? 1.05
            : width > 700
                ? 0.9
                : 0.75,
      ),

                        itemCount:
                            filteredProducts.length,

                        itemBuilder:
                            (context, index) {

                          final product =
                              filteredProducts[
                                  index];

                          return GestureDetector(

                            onTap: () {

                              cartNotifier
                                  .addToCart(
                                product,
                              );
                            },

                            child: AnimatedContainer(

                              duration:
                                  const Duration(
                                milliseconds: 200,
                              ),

                              padding:
                                  const EdgeInsets.all(
                                18,
                              ),

                              decoration:
                                  BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                    BorderRadius.circular(
                                  24,
                                ),

                                boxShadow: [

                                  BoxShadow(

                                    color:
                                        Colors.black
                                            .withOpacity(
                                      0.04,
                                    ),

                                    blurRadius: 14,
                                    offset:
                                        const Offset(
                                      0,
                                      6,
                                    ),
                                  ),
                                ],
                              ),

                              child: Column(

  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

                                  Row(

                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,

                                    children: [

                                      Expanded(

                                        child: Text(

                                          product.name,

                                          maxLines: 1,

                                          overflow:
                                              TextOverflow
                                                  .ellipsis,

                                          style:
                                              const TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),

                                      Container(

                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal:
                                              10,
                                          vertical: 5,
                                        ),

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              product.stock <=
                                                      5
                                                  ? Colors.red
                                                      .shade100
                                                  : Colors.green
                                                      .shade100,

                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),

                                        child: Text(

                                          'Stock ${product.stock}',

                                          style:
                                              TextStyle(

                                            fontSize: 12,

                                            color:
                                                product.stock <=
                                                        5
                                                    ? Colors.red
                                                    : Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  

                                  FittedBox(

  alignment:
      Alignment.centerLeft,

  child: Text(

    '₹ ${product.price.toStringAsFixed(2)}',

    style:
        const TextStyle(
      fontSize: 28,
                                      color: Colors.blue,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  ),


                                  const SizedBox(
                                    height: 14,
                                  ),

                                  SizedBox(

                                    width:
                                        double.infinity,

                                    height: 48,

                                    child: ElevatedButton.icon(

                                      onPressed: () {

                                        cartNotifier
                                            .addToCart(
                                          product,
                                        );
                                      },

                                      icon: const Icon(
                                        Icons.add,
                                      ),

                                      label: const FittedBox(
  child: Text(
    'Add to Cart',
  ),
),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                                              );
                      },
                    );
                                    },
                  ), // productState.when
                ), // Expanded
              ],
            ),
          ),
                  
                

const SizedBox(width:20),
          // RIGHT SIDE CART
          Container(

  width:
      MediaQuery.of(context)
                  .size
                  .width >
              1200
          ? 430
          : 340,

            padding:
                const EdgeInsets.all(24),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                24,
              ),
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'Current Bill',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),

    if (cart.isNotEmpty)
      TextButton.icon(
        onPressed: () {
          cartNotifier.clearCart();
        },
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.red,
        ),
        label: const Text(
          'Clear Cart',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
  ],
),

                const SizedBox(height: 25),

                Expanded(

                  child: cart.isEmpty

                      ? Center(

                          child: Column(

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 90,
                                color:
                                    Colors.grey.shade400,
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Text(

                                'Cart is Empty',

                                style: TextStyle(
                                  fontSize: 22,
                                  color:
                                      Colors.grey.shade600,
                                ),
                              ),
                            ],
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
                                bottom: 18,
                              ),

                              padding:
                                  const EdgeInsets.all(
                                18,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    Colors.grey.shade100,

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

                                  Row(

                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,

                                    children: [

                                      Expanded(

                                        child: Text(

                                          item.product.name,

                                          style:
                                              const TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),

                                      IconButton(

                                        onPressed: () {

                                          cartNotifier
                                              .removeFromCart(
                                            item.product,
                                          );
                                        },

                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  Row(

                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,

                                    children: [

                                      Container(

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              Colors.white,

                                          borderRadius:
                                              BorderRadius.circular(
                                            14,
                                          ),
                                        ),

                                        child: Row(

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
                                                Icons.remove,
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
                                                Icons.add,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(

                                        '₹ ${item.total.toStringAsFixed(2)}',

                                        style:
                                            const TextStyle(
                                          fontSize: 20,
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
                    22,
                  ),

                  decoration: BoxDecoration(

                    color:
                        Colors.blue.shade50,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Column(

                    children: [

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          const Text(

                            'Total',

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          Text(

                            '₹ ${cartNotifier.totalAmount.toStringAsFixed(2)}',

                            style:
                                const TextStyle(
                              fontSize: 32,
                              color: Colors.blue,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(

                        width:
                            double.infinity,

                        height: 60,

                        child: ElevatedButton(

                          onPressed: () {

                            showDialog(

                              context: context,

                              builder: (_) =>
                                  CheckoutDialog(

                                subtotal:
                                    cartNotifier
                                        .totalAmount,

                                items: cart,
                              ),
                            );
                          },

                          child: const Text(

                            'Checkout',

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}