import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/role_provider.dart';

class AppSidebar extends ConsumerWidget {
  

  final int selectedIndex;

  final Function(int)
      onItemSelected;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final roleState =
        ref.watch(roleProvider);

    final role =
        roleState.value ?? 'cashier';
        print('CURRENT ROLE: $role');

    return Container(

      width: 250,

      color:
          const Color(0xFF1E293B),

      child: Column(

        children: [

  const SizedBox(height: 40),

  const Text(

    'Buzz POS',

    style: TextStyle(
      color: Colors.white,
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
  ),

  const SizedBox(height: 40),

  // DASHBOARD
  if (role == 'admin')

    sidebarItem(
      Icons.dashboard,
      'Dashboard',
      0,
    ),

  // PRODUCTS
  if (role == 'admin')

    sidebarItem(
      Icons.shopping_bag,
      'Products',
      1,
    ),

  // CUSTOMERS
  sidebarItem(
    Icons.people,
    'Customers',
    2,
  ),

  // BILLING
  sidebarItem(
    Icons.point_of_sale,
    'Billing',
    3,
  ),

  // SALES
  if (role == 'admin')

    sidebarItem(
      Icons.receipt_long,
      'Sales',
      4,
    ),

  // PUSHES LOGOUT TO BOTTOM
  const Spacer(),

  // LOGOUT BUTTON
  Padding(

    padding: const EdgeInsets.all(16),

    child: GestureDetector(

      onTap: () async {

        await Supabase
            .instance
            .client
            .auth
            .signOut();
      },

      child: Container(

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(

          borderRadius:
              BorderRadius.circular(12),

          color: Colors.red
              .withOpacity(0.15),
        ),

        child: const Row(

          children: [

            Icon(
              Icons.logout,
              color: Colors.red,
            ),

            SizedBox(width: 14),

            Text(

              'Logout',

              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
],
      ),
    );
  }

  Widget sidebarItem(
    IconData icon,
    String title,
    int index,
  ) {

    final isSelected =
        selectedIndex == index;

    return GestureDetector(

      onTap: () =>
          onItemSelected(index),

      child: Padding(

        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        child: Container(

          padding:
              const EdgeInsets.all(14),

          decoration: BoxDecoration(

            borderRadius:
                BorderRadius.circular(
              12,
            ),

            color: isSelected
                ? Colors.blue
                : Colors.white.withOpacity(
                    0.05,
                  ),
          ),

          child: Row(

            children: [

              Icon(
                icon,
                color: Colors.white,
              ),

              const SizedBox(width: 14),

              Text(

                title,

                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
