import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/product_service.dart';
import '../../services/sales_service.dart';

final dashboardProvider =
FutureProvider<Map<String, dynamic>>(
  (ref) async {

    final products =
        await ProductService()
            .fetchProducts();

    final sales =
        await SalesService()
            .fetchSales();

    double revenue = 0;

    for (var sale in sales) {

      revenue +=
          (sale['total'] ?? 0)
              .toDouble();
    }

    final lowStockProducts =
        products.where(
      (product) =>
          product.stock <= 5,
    ).length;

    return {

      'totalProducts':
          products.length,

      'totalSales':
          sales.length,

      'totalRevenue':
          revenue,

      'lowStock':
          lowStockProducts,

      'recentSales':
          sales.take(5).toList(),
    };
  },
);