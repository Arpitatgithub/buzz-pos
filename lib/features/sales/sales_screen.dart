import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'sales_provider.dart';

class SalesScreen
    extends ConsumerWidget {

  const SalesScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final salesState =
        ref.watch(salesProvider);

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(

          'Sales History',

          style: TextStyle(
            fontSize: 32,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        salesState.when(

          loading: () =>
              const Expanded(
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              ),

          error: (e, _) =>
              Expanded(
                child: Center(
                  child: Text(
                    e.toString(),
                  ),
                ),
              ),

          data: (sales) {

            double totalRevenue = 0;

            for (var sale in sales) {

              totalRevenue +=
                  (sale['total'] ?? 0)
                      .toDouble();
            }

            return Expanded(

              child: Column(

                children: [

                  // ANALYTICS CARDS
                  Row(
                    children: [

                      analyticsCard(
                        'Total Sales',
                        '${sales.length}',
                        Icons.receipt_long,
                      ),

                      const SizedBox(
                        width: 20,
                      ),

                      analyticsCard(
                        'Revenue',
                        '₹ ${totalRevenue.toStringAsFixed(2)}',
                        Icons.currency_rupee,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // SALES TABLE
                  Expanded(

                    child: Container(

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),

                      child:
                          SingleChildScrollView(

                        child: DataTable(

                          columnSpacing: 40,

                          headingRowColor:
                              WidgetStateProperty.all(
                            Colors.grey.shade200,
                          ),

                          columns: const [

                            DataColumn(
                              label: Text(
                                'Date',
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                'Subtotal',
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                'GST',
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                'Discount',
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                'Total',
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                'Payment',
                              ),
                            ),
                          ],

                          rows: sales.map((sale) {

                            return DataRow(

                              cells: [

                                DataCell(

                                  Text(

                                    DateFormat(
                                      'dd MMM yyyy • hh:mm a',
                                    ).format(
                                      DateTime.parse(
                                        sale[
                                            'created_at'],
                                      ),
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    '₹ ${sale['subtotal']}',
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    '₹ ${sale['gst']}',
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    '₹ ${sale['discount']}',
                                  ),
                                ),

                                DataCell(

                                  Text(

                                    '₹ ${sale['total']}',

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),

                                DataCell(

                                  Container(

                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal:
                                          12,
                                      vertical: 6,
                                    ),

                                    decoration:
                                        BoxDecoration(

                                      color:
                                          Colors.blue
                                              .shade100,

                                      borderRadius:
                                          BorderRadius.circular(
                                        20,
                                      ),
                                    ),

                                    child: Text(
                                      sale[
                                          'payment_method'],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget analyticsCard(
    String title,
    String value,
    IconData icon,
  ) {

    return Expanded(

      child: Container(

        height: 140,

        padding:
            const EdgeInsets.all(
          20,
        ),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(

              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                Icon(icon),
              ],
            ),

            const Spacer(),

            Text(
              value,

              style: const TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}