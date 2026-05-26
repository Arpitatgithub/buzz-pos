import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/customer_model.dart';
import 'customer_provider.dart';

class CustomersScreen
    extends ConsumerWidget {

  const CustomersScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final customerState =
        ref.watch(customerProvider);

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Row(

          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

          children: [

            const Text(

              'Customers',

              style: TextStyle(
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            ElevatedButton(

              onPressed: () {

                showDialog(
                  context: context,
                  builder: (_) =>
                      const AddCustomerDialog(),
                );
              },

              child: const Text(
                'Add Customer',
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        Expanded(

          child: Container(

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

            child: customerState.when(

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

              data: (customers) {

                if (customers.isEmpty) {

                  return const Center(
                    child: Text(
                      'No Customers Found',
                    ),
                  );
                }

                return SingleChildScrollView(

                  child: DataTable(

                    columnSpacing: 40,

                    headingRowColor:
                        WidgetStateProperty.all(
                      Colors.grey.shade200,
                    ),

                    columns: const [

                      DataColumn(
                        label: Text(
                          'Name',
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Phone',
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Email',
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Address',
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Actions',
                        ),
                      ),
                    ],

                    rows:
                        customers.map((customer) {

                      return DataRow(

                        cells: [

                          DataCell(
                            Text(customer.name),
                          ),

                          DataCell(
                            Text(customer.phone),
                          ),

                          DataCell(
                            Text(customer.email),
                          ),

                          DataCell(
                            Text(customer.address),
                          ),

                          DataCell(

                            IconButton(

                              onPressed: () async {

                                await ref
                                    .read(
                                      customerProvider
                                          .notifier,
                                    )
                                    .deleteCustomer(
                                      customer.id,
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

class AddCustomerDialog
    extends ConsumerStatefulWidget {

  const AddCustomerDialog({
    super.key,
  });

  @override
  ConsumerState<AddCustomerDialog>
      createState() =>
          _AddCustomerDialogState();
}

class _AddCustomerDialogState
    extends ConsumerState<AddCustomerDialog> {

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final addressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        'Add Customer',
      ),

      content: SizedBox(

        width: 400,

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            TextField(
              controller:
                  nameController,

              decoration:
                  const InputDecoration(
                labelText: 'Name',
              ),
            ),

            TextField(
              controller:
                  phoneController,

              decoration:
                  const InputDecoration(
                labelText: 'Phone',
              ),
            ),

            TextField(
              controller:
                  emailController,

              decoration:
                  const InputDecoration(
                labelText: 'Email',
              ),
            ),

            TextField(
              controller:
                  addressController,

              decoration:
                  const InputDecoration(
                labelText: 'Address',
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

            final customer =
                CustomerModel(

              id: const Uuid().v4(),

              name:
                  nameController.text,

              phone:
                  phoneController.text,

              email:
                  emailController.text,

              address:
                  addressController.text,
            );

            await ref
                .read(
                  customerProvider.notifier,
                )
                .addCustomer(customer);

            if (context.mounted) {
              Navigator.pop(context);
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