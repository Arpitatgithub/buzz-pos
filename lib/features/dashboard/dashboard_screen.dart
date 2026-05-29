import '../users/users_screen.dart';
import 'package:fl_chart/fl_chart.dart';
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

  @override
void initState() {

  super.initState();

  final user =
      Supabase.instance.client
          .auth.currentUser;

  if (user?.email ==
      'cashier@buzz.com') {

    selectedIndex = 3;
  }
}
  int selectedIndex = 0;

  final screens = [
  const DashboardHome(),
  const ProductsScreen(),
  const CustomersScreen(),
  const BillingScreen(),
  const SalesScreen(),
  const UsersScreen(),
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

        return SingleChildScrollView(

          child: Column(

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

              Wrap(

                spacing: 20,
                runSpacing: 20,

                children: [

                  dashboardCard(
                    'Revenue',
                    '₹ ${data['totalRevenue']}',
                    Icons.currency_rupee,
                  ),

                  dashboardCard(
                    'Sales',
                    '${data['totalSales']}',
                    Icons.receipt_long,
                  ),

                  dashboardCard(
                    'Products',
                    '${data['totalProducts']}',
                    Icons.inventory_2,
                  ),

                  dashboardCard(
                    'Customers',
                    '${data['totalCustomers'] ?? 0}',
                    Icons.people,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Align(

                alignment:
                    Alignment.centerLeft,

                child: ElevatedButton.icon(

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
              ),

              const SizedBox(height: 30),

              salesChart(),

              const SizedBox(height: 30),

              Container(

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

                    ListView.builder(

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      itemCount:
                          data['recentSales']
                              .length,

                      itemBuilder:
                          (context, index) {

                        final sale =
                            data['recentSales']
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget salesChart() {

    return Container(

      height: 320,

      padding:
          const EdgeInsets.all(
        24,
      ),

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

          const Text(

            'Sales Analytics',

            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(

            child: LineChart(

              LineChartData(

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                ),

                borderData:
                    FlBorderData(
                  show: false,
                ),

                titlesData:
                    const FlTitlesData(
                  show: false,
                ),

                lineBarsData: [

                  LineChartBarData(

                    spots: const [

                      FlSpot(0, 1),
                      FlSpot(1, 3),
                      FlSpot(2, 2),
                      FlSpot(3, 5),
                      FlSpot(4, 3.5),
                      FlSpot(5, 6),
                      FlSpot(6, 4),
                    ],

                    isCurved: true,

                    barWidth: 5,

                    dotData:
                        const FlDotData(
                      show: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dashboardCard(
    String title,
    String value,
    IconData icon,
  ) {

    return SizedBox(

      width: 280,

      child: Container(

        height: 160,

        padding:
            const EdgeInsets.all(
          24,
        ),

        decoration: BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Colors.blue.shade500,
              Colors.blue.shade700,
            ],
          ),

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.blue.withOpacity(
                0.2,
              ),

              blurRadius: 20,

              offset:
                  const Offset(0, 10),
            ),
          ],
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

                  style:
                      const TextStyle(

                    fontSize: 16,

                    color:
                        Colors.white70,

                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                Container(

                  padding:
                      const EdgeInsets.all(
                    12,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.white
                        .withOpacity(
                      0.15,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),

                  child: Icon(

                    icon,

                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Text(

              value,

              style: const TextStyle(

                fontSize: 34,

                fontWeight:
                    FontWeight.bold,

                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}