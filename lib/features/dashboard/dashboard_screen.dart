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

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        Row(
          children: [
            dashboardCard(
              'Total Sales',
              '₹ 25,000',
            ),

            const SizedBox(width: 20),

            dashboardCard(
              'Products',
              '120',
            ),

            const SizedBox(width: 20),

            dashboardCard(
              'Customers',
              '45',
            ),
          ],
        ),
      ],
    );
  }

  Widget dashboardCard(
    String title,
    String value,
  ) {
    return Expanded(
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}