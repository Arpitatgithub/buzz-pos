import '../core/supabase_client.dart';
import '../models/customer_model.dart';

class CustomerService {

  Future<List<CustomerModel>>
      fetchCustomers() async {

    final response =
        await supabase
            .from('customers')
            .select()
            .order(
              'created_at',
              ascending: false,
            );

    return response
        .map<CustomerModel>(
          (customer) =>
              CustomerModel.fromMap(
            customer,
          ),
        )
        .toList();
  }

  Future<void> addCustomer(
    CustomerModel customer,
  ) async {

    await supabase
        .from('customers')
        .insert(
          customer.toMap(),
        );
  }

  Future<void> deleteCustomer(
    String id,
  ) async {

    await supabase
        .from('customers')
        .delete()
        .eq('id', id);
  }
}