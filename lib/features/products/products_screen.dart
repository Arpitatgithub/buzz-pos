import 'package:flutter/material.dart';
import 'search_provider.dart';
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

    final searchQuery =
    ref.watch(productSearchProvider);

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

        SizedBox(
  width: 350,

  child: TextField(

    decoration: InputDecoration(
      hintText: 'Search products...',
      prefixIcon:
          const Icon(Icons.search),

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    onChanged: (value) {

      ref
          .read(
            productSearchProvider
                .notifier,
          )
          .state = value;
    },
  ),
),

const SizedBox(height: 20),

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
                final filteredProducts =
    products.where((product) {

  final query =
      searchQuery.toLowerCase();

  return product.name
          .toLowerCase()
          .contains(query) ||
      product.barcode
          .toLowerCase()
          .contains(query);
}).toList();
if (filteredProducts.isEmpty) {

                  return const Center(
                    child: Text(
                      'No Products Added',
                    ),
                  );
                }

                return SingleChildScrollView(

  scrollDirection: Axis.vertical,

  child: DataTable(

    columnSpacing: 40,

    headingRowColor:
        WidgetStateProperty.all(
      Colors.grey.shade200,
    ),

    columns: const [

      DataColumn(
        label: Text(
          'Product',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      DataColumn(
        label: Text(
          'Barcode',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      DataColumn(
        label: Text(
          'Category',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      DataColumn(
        label: Text(
          'Price',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      DataColumn(
        label: Text(
          'Stock',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      DataColumn(
        label: Text(
          'Actions',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    ],

    rows: filteredProducts.map((product) {

      return DataRow(
        cells: [

          DataCell(
            Text(product.name),
          ),

          DataCell(
            Text(product.barcode),
          ),

          DataCell(
            Text(product.category),
          ),

          DataCell(
            Text(
              '₹ ${product.price}',
            ),
          ),

          DataCell(

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              decoration: BoxDecoration(

                color: product.stock <= 5
                    ? Colors.red.shade100
                    : Colors.green.shade100,

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Text(
                '${product.stock}',

                style: TextStyle(

                  color: product.stock <= 5
                      ? Colors.red
                      : Colors.green,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          DataCell(

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
          ),
        ],
      );
    }).toList(),
  ),
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