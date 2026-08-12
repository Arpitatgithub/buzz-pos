import '../../services/storage_service.dart';
import 'package:flutter/material.dart';
import 'search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/product_model.dart';
import '../../providers/user_profile_provider.dart';
import 'product_provider.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productState =
        ref.watch(productProvider);

    final profileAsync =
        ref.watch(userProfileProvider);

    final isAdmin =
        profileAsync.value?.role == 'admin';

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

  Row(

    children: [

      ClipRRect(

        borderRadius:
            BorderRadius.circular(10),

        child: product.imageUrl.isEmpty

            ? Container(

                width: 50,
                height: 50,

                color:
                    Colors.grey.shade200,

                child: const Icon(
                  Icons.image,
                ),
              )

            : Image.network(

                product.imageUrl,

                width: 50,
                height: 50,

                fit: BoxFit.cover,
              ),
      ),

      const SizedBox(width: 14),

      Text(product.name),
    ],
  ),
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

  Row(
    children: [

      if (isAdmin)
        IconButton(
          tooltip: 'Adjust Stock',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) =>
                  AdjustStockDialog(
                product: product,
              ),
            );
          },
          icon: const Icon(
            Icons.inventory_2_outlined,
            color: Colors.orange,
          ),
        ),

      IconButton(
        tooltip: 'Edit Product',
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                EditProductDialog(
              product: product,
            ),
          );
        },
        icon: const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
      ),

      IconButton(

        onPressed: () async {

          final shouldDelete =
              await showDialog<bool>(

            context: context,

            builder: (_) {

              return AlertDialog(

                title: const Text(
                  'Delete Product',
                ),

                content: const Text(
                  'Are you sure you want to delete this product?',
                ),

                actions: [

                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        false,
                      );
                    },
                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        true,
                      );
                    },
                    child: const Text(
                      'Delete',
                    ),
                  ),
                ],
              );
            },
          );

          if (shouldDelete == true) {

            await ref
                .read(
                  productProvider.notifier,
                )
                .deleteProduct(
                  product.id,
                );
          }
        },

        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    ],
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
      String imageUrl = '';

final storageService =
    StorageService();

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

    const SizedBox(height: 20),

    GestureDetector(

      onTap: () async {

        final uploadedImage =
            await storageService
                .uploadProductImage();

        if (uploadedImage.isNotEmpty) {

          setState(() {

            imageUrl =
                uploadedImage;
          });
        }
      },

      child: Container(

        height: 160,
        width: double.infinity,

        decoration: BoxDecoration(

          color: Colors.grey.shade100,

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: imageUrl.isEmpty

            ? Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: const [

                  Icon(
                    Icons.cloud_upload,
                    size: 50,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Upload Product Image',
                  ),
                ],
              )

            : ClipRRect(

                borderRadius:
                    BorderRadius.circular(16),

                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
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

  imageUrl: imageUrl,
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

class EditProductDialog
    extends ConsumerStatefulWidget {

  final ProductModel product;

  const EditProductDialog({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<EditProductDialog>
      createState() =>
          _EditProductDialogState();
}

class _EditProductDialogState
    extends ConsumerState<EditProductDialog> {

      

  late TextEditingController
      nameController;

  late TextEditingController
      barcodeController;

  late TextEditingController
      priceController;

  late TextEditingController
      stockController;

  late TextEditingController
      categoryController;

   late String imageUrl;

  final storageService =
      StorageService();    

  @override
void initState() {

  super.initState();

  nameController =
      TextEditingController(
    text: widget.product.name,
  );

  barcodeController =
      TextEditingController(
    text: widget.product.barcode,
  );

  priceController =
      TextEditingController(
    text:
        widget.product.price.toString(),
  );

  stockController =
      TextEditingController(
    text:
        widget.product.stock.toString(),
  );

  categoryController =
      TextEditingController(
    text: widget.product.category,
  );

  imageUrl =
      widget.product.imageUrl;
}

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        'Edit Product',
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
              controller:
                  priceController,
              decoration:
                  const InputDecoration(
                labelText: 'Price',
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
            const SizedBox(height: 20),

GestureDetector(

  onTap: () async {

    final uploadedImage =
        await storageService
            .uploadProductImage();

    if (uploadedImage.isNotEmpty) {

      setState(() {

        imageUrl =
            uploadedImage;
      });
    }
  },

  child: Container(

    height: 160,
    width: double.infinity,

    decoration: BoxDecoration(

      color: Colors.grey.shade100,

      borderRadius:
          BorderRadius.circular(16),

      border: Border.all(
        color: Colors.grey.shade300,
      ),
    ),

    child: imageUrl.isEmpty

        ? Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: const [

              Icon(
                Icons.cloud_upload,
                size: 50,
                color: Colors.grey,
              ),

              SizedBox(height: 10),

              Text(
                'Upload Product Image',
              ),
            ],
          )

        : ClipRRect(

            borderRadius:
                BorderRadius.circular(16),

            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
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

    final updatedProduct =
        ProductModel(

      id: widget.product.id,

      name:
          nameController.text,

      barcode:
          barcodeController.text,

      price:
          double.tryParse(
                priceController.text,
              ) ??
              0,

      // Stock is managed separately through
      // the audited stock-adjustment flow.
      stock: widget.product.stock,

      category:
          categoryController.text,

      imageUrl: imageUrl,
    );

    await ref
        .read(
          productProvider.notifier,
        )
        .updateProduct(
          updatedProduct,
        );

    if (context.mounted) {
      Navigator.pop(context);
    }
  },

  child: const Text(
    'Update',
  ),
),
      ],
    );
  }
}

class AdjustStockDialog extends ConsumerStatefulWidget {
  final ProductModel product;

  const AdjustStockDialog({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<AdjustStockDialog> createState() =>
      _AdjustStockDialogState();
}

class _AdjustStockDialogState
    extends ConsumerState<AdjustStockDialog> {
  final quantityController =
      TextEditingController();

  String selectedReason = 'Damaged';

  bool saving = false;

  static const reasons = [
    'Damaged',
    'Expired',
    'Lost',
    'Manual correction',
    'Supplier return',
    'Other',
  ];

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  Future<void> _adjustStock() async {
    if (saving) {
      return;
    }

    final quantityChange =
        int.tryParse(
          quantityController.text.trim(),
        );

    if (quantityChange == null ||
        quantityChange == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid stock adjustment. Use +10 to add or -5 to remove stock.',
          ),
        ),
      );
      return;
    }

    final newStock =
        widget.product.stock + quantityChange;

    if (newStock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stock cannot go below 0. Current stock: ${widget.product.stock}.',
          ),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await ref
          .read(productProvider.notifier)
          .adjustStock(
            productId: widget.product.id,
            quantityChange: quantityChange,
            reason: selectedReason,
          );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stock updated: ${widget.product.stock} → $newStock',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        saving = false;
      });

      var message = e.toString();

      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quantityChange =
        int.tryParse(
              quantityController.text.trim(),
            ) ??
            0;

    final newStock =
        widget.product.stock + quantityChange;

    return AlertDialog(
      title: const Text('Adjust Stock'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Current stock: ${widget.product.stock}',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: quantityController,
              enabled: !saving,
              keyboardType:
                  const TextInputType.numberWithOptions(
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Quantity change',
                hintText: 'Example: +10 or -5',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              value: selectedReason,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              items: reasons
                  .map(
                    (reason) =>
                        DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    ),
                  )
                  .toList(),
              onChanged: saving
                  ? null
                  : (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        selectedReason = value;
                      });
                    },
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New stock',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    newStock < 0
                        ? 'Invalid'
                        : '$newStock',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: newStock < 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: saving
              ? null
              : _adjustStock,
          child: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Adjust Stock'),
        ),
      ],
    );
  }
}

