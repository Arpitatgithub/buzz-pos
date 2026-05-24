import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/cart_item_model.dart';

class InvoiceService {

  Future<Uint8List> generateInvoice({

    required List<CartItemModel> items,

    required double subtotal,
    required double gst,
    required double discount,
    required double total,

    required String paymentMethod,
  }) async {

    final pdf = pw.Document();

    pdf.addPage(

      pw.Page(

        pageFormat: PdfPageFormat.a4,

        build: (context) {

          return pw.Padding(

            padding:
                const pw.EdgeInsets.all(24),

            child: pw.Column(

              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,

              children: [

                pw.Text(

                  'Buzz POS Invoice',

                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight:
                        pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text(
                  'Date: ${DateTime.now()}',
                ),

                pw.Text(
                  'Payment: $paymentMethod',
                ),

                pw.SizedBox(height: 30),

                pw.Table(

                  border:
                      pw.TableBorder.all(),

                  children: [

                    pw.TableRow(

                      decoration:
                          const pw.BoxDecoration(
                        color:
                            PdfColors.grey300,
                      ),

                      children: [

                        tableCell(
                          'Product',
                        ),

                        tableCell(
                          'Qty',
                        ),

                        tableCell(
                          'Price',
                        ),

                        tableCell(
                          'Total',
                        ),
                      ],
                    ),

                    ...items.map(

                      (item) {

                        return pw.TableRow(
                          children: [

                            tableCell(
                              item.product.name,
                            ),

                            tableCell(
                              item.quantity
                                  .toString(),
                            ),

                            tableCell(
                              item.product.price
                                  .toString(),
                            ),

                            tableCell(
                              item.total
                                  .toStringAsFixed(
                                2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                pw.SizedBox(height: 30),

                summaryRow(
                  'Subtotal',
                  subtotal,
                ),

                summaryRow(
                  'GST',
                  gst,
                ),

                summaryRow(
                  'Discount',
                  discount,
                ),

                pw.Divider(),

                summaryRow(
                  'Grand Total',
                  total,
                  isBold: true,
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget tableCell(
    String text,
  ) {

    return pw.Padding(

      padding:
          const pw.EdgeInsets.all(10),

      child: pw.Text(text),
    );
  }

  pw.Widget summaryRow(
    String title,
    double amount, {

    bool isBold = false,
  }) {

    return pw.Padding(

      padding:
          const pw.EdgeInsets.only(
        bottom: 10,
      ),

      child: pw.Row(

        mainAxisAlignment:
            pw.MainAxisAlignment
                .spaceBetween,

        children: [

          pw.Text(

            title,

            style: pw.TextStyle(
              fontWeight: isBold
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
            ),
          ),

          pw.Text(

            '₹ ${amount.toStringAsFixed(2)}',

            style: pw.TextStyle(
              fontWeight: isBold
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}