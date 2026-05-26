import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_provider.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_sidebar.dart';
import '../billing/billing_screen.dart';
import '../customers/customers_screen.dart';
import '../products/products_screen.dart';
import '../sales/sales_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int selectedIndex = 0;

  final screens = [
    const DashboardHome(),
    const ProductsScreen(),
    const CustomersScreen(),
    const BillingScreen(),
    const SalesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: screens[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardHome
    extends ConsumerWidget {

  const DashboardHome({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final dashboardState =
        ref.watch(
      dashboardProvider,
    );

    return dashboardState.when(

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

      data: (data) {

        return Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              'Dashboard',

              style: TextStyle(
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // ANALYTICS CARDS
            Row(

  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  children: [

    const Text(

      'Dashboard',

      style: TextStyle(
        fontSize: 32,
        fontWeight:
            FontWeight.bold,
      ),
    ),

    ElevatedButton.icon(

      onPressed: () async {

        await Supabase
            .instance
            .client
            .auth
            .signOut();
      },

      icon: const Icon(
        Icons.logout,
      ),

      label: const Text(
        'Logout',
      ),
    ),
  ],
),

            const SizedBox(height: 40),

            // RECENT SALES
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

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    const Text(

                      'Recent Sales',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Expanded(

                      child: ListView.builder(

                        itemCount:
                            data[
                                    'recentSales']
                                .length,

                        itemBuilder:
                            (context, index) {

                          final sale =
                              data[
                                      'recentSales']
                                  [index];

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

                            child: Row(

                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [

                                Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      sale[
                                          'payment_method'],

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    Text(
                                      sale[
                                          'created_at'],
                                    ),
                                  ],
                                ),

                                Text(

                                  '₹ ${sale['total']}',

                                  style:
                                      const TextStyle(
                                    fontSize: 22,
                                    color:
                                        Colors.blue,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget dashboardCard(
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