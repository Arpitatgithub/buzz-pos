import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/product_model.dart';
import 'product_provider.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productState =
        ref.watch(productProvider);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [

            const Text(
              'Products',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            ElevatedButton(
              onPressed: () {

                showDialog(
                  context: context,
                  builder: (_) =>
                      const AddProductDialog(),
                );
              },
              child: const Text(
                'Add Product',
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
            ),

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

                if (products.isEmpty) {

                  return const Center(
                    child: Text(
                      'No Products Added',
                    ),
                  );
                }

                return ListView.builder(

                  itemCount: products.length,

                  itemBuilder: (context, index) {

                    final product =
                        products[index];

                    return ListTile(

                      title: Text(
                        product.name,
                      ),

                      subtitle: Text(
                        'Barcode: ${product.barcode}',
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [

                          Text(
                            '₹ ${product.price}',
                          ),

                          IconButton(
                            onPressed: () {

                              ref
                                  .read(
                                    productProvider
                                        .notifier,
                                  )
                                  .deleteProduct(
                                    product.id,
                                  );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AddProductDialog
    extends ConsumerStatefulWidget {

  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog>
      createState() =>
          _AddProductDialogState();
}

class _AddProductDialogState
    extends ConsumerState<AddProductDialog> {

  final nameController =
      TextEditingController();

  final barcodeController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final stockController =
      TextEditingController();

  final categoryController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        'Add Product',
      ),

      content: SizedBox(
        width: 400,

        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [

            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(
                labelText: 'Name',
              ),
            ),

            TextField(
              controller:
                  barcodeController,
              decoration:
                  const InputDecoration(
                labelText: 'Barcode',
              ),
            ),

            TextField(
              controller: priceController,
              decoration:
                  const InputDecoration(
                labelText: 'Price',
              ),
            ),

            TextField(
              controller: stockController,
              decoration:
                  const InputDecoration(
                labelText: 'Stock',
              ),
            ),

            TextField(
              controller:
                  categoryController,
              decoration:
                  const InputDecoration(
                labelText: 'Category',
              ),
            ),
          ],
        ),
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
          ),
        ),

        ElevatedButton(
  onPressed: () async {

    try {

      final product = ProductModel(
        id: const Uuid().v4(),

        name: nameController.text,

        barcode: barcodeController.text,

        price: double.tryParse(
              priceController.text,
            ) ??
            0,

        stock: int.tryParse(
              stockController.text,
            ) ??
            0,

        category: categoryController.text,
      );

      await ref
          .read(productProvider.notifier)
          .addProduct(product);

      if (context.mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Product Added Successfully',
            ),
          ),
        );

        Navigator.pop(context);
      }

    } catch (e) {

      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  },

  child: const Text(
    'Save',
  ),
),
      ],
    );
  }
}