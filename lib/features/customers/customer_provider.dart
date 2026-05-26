import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/customer_model.dart';
import '../../services/customer_service.dart';

final customerProvider =
StateNotifierProvider<
    CustomerNotifier,
    AsyncValue<List<CustomerModel>>>(
  (ref) => CustomerNotifier(),
);

class CustomerNotifier
    extends StateNotifier<
        AsyncValue<List<CustomerModel>>> {

  final CustomerService service =
      CustomerService();

  CustomerNotifier()
      : super(const AsyncLoading()) {

    loadCustomers();
  }

  Future<void> loadCustomers() async {

    try {

      final customers =
          await service.fetchCustomers();

      state = AsyncData(customers);

    } catch (e, stack) {

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  Future<void> addCustomer(
    CustomerModel customer,
  ) async {

    await service.addCustomer(
      customer,
    );

    await loadCustomers();
  }

  Future<void> deleteCustomer(
    String id,
  ) async {

    await service.deleteCustomer(
      id,
    );

    await loadCustomers();
  }
}