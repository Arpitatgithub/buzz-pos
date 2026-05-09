import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF1E293B),
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

          sidebarItem(Icons.dashboard, 'Dashboard', 0),
          sidebarItem(Icons.shopping_bag, 'Products', 1),
          sidebarItem(Icons.people, 'Customers', 2),
          sidebarItem(Icons.point_of_sale, 'Billing', 3),
          sidebarItem(Icons.receipt_long, 'Sales', 4),
        ],
      ),
    );
  }

  Widget sidebarItem(
    IconData icon,
    String title,
    int index,
  ) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Colors.blue
                : Colors.white.withOpacity(0.05),
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
                style: const TextStyle(
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