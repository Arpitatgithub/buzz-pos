import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/sales_service.dart';

final salesProvider =
FutureProvider<List<Map<String, dynamic>>>(
  (ref) async {

    return SalesService()
        .fetchSales();
  },
);