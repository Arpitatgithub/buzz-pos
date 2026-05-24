import '../../models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/sale_model.dart';
import '../../services/sales_service.dart';
import 'cart_provider.dart';
import 'package:printing/printing.dart';

import '../../services/invoice_service.dart';

class CheckoutDialog
    extends ConsumerStatefulWidget {

  final double subtotal;

  final List<CartItemModel> items;

  const CheckoutDialog({
    super.key,
    required this.subtotal,
    required this.items,
  });

  @override
  ConsumerState<CheckoutDialog>
      createState() =>
          _CheckoutDialogState();
}

class _CheckoutDialogState
    extends ConsumerState<CheckoutDialog> {

  final discountController =
      TextEditingController();

  String paymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {

    final discount =
        double.tryParse(
              discountController.text,
            ) ??
            0;

    final gst =
        widget.subtotal * 0.18;

    final total =
        widget.subtotal +
            gst -
            discount;

    return AlertDialog(

      title: const Text(
        'Checkout',
      ),

      content: SizedBox(

        width: 420,

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            billRow(
              'Subtotal',
              widget.subtotal,
            ),

            billRow(
              'GST (18%)',
              gst,
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
                  discountController,

              decoration:
                  const InputDecoration(
                labelText: 'Discount',
              ),

              onChanged: (_) {
                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(

              value: paymentMethod,

              items: const [

                DropdownMenuItem(
                  value: 'Cash',
                  child: Text('Cash'),
                ),

                DropdownMenuItem(
                  value: 'Card',
                  child: Text('Card'),
                ),

                DropdownMenuItem(
                  value: 'UPI',
                  child: Text('UPI'),
                ),
              ],

              onChanged: (value) {

                setState(() {

                  paymentMethod =
                      value!;
                });
              },
            ),

            const SizedBox(height: 30),

            Container(

              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration: BoxDecoration(

                color:
                    Colors.blue.shade50,

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: Row(

                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(
                    'Grand Total',

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    '₹ ${total.toStringAsFixed(2)}',

                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight:
                          FontWeight.bold,
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
          ),
        ),

        ElevatedButton(

          onPressed: () async {

            final sale = SaleModel(

              id: const Uuid().v4(),

              subtotal:
                  widget.subtotal,

              gst: gst,

              discount: discount,

              total: total,

              paymentMethod:
                  paymentMethod,

              createdAt:
                  DateTime.now(),
            );

            await SalesService()
                .createSale(sale);
                final pdfData =
    await InvoiceService()
        .generateInvoice(

  items: widget.items,

  subtotal: widget.subtotal,

  gst: gst,

  discount: discount,

  total: total,

  paymentMethod:
      paymentMethod,
);

await Printing.layoutPdf(
  onLayout: (_) async => pdfData,
);

            ref
                .read(
                  cartProvider.notifier,
                )
                .clearCart();

            if (context.mounted) {

              Navigator.pop(context);

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                const SnackBar(
                  content: Text(
                    'Sale Completed',
                  ),
                ),
              );
            }
          },

          child: const Text(
            'Complete Sale',
          ),
        ),
      ],
    );
  }

  Widget billRow(
    String title,
    double amount,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          Text(
            '₹ ${amount.toStringAsFixed(2)}',

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}