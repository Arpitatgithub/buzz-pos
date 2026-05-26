import '../core/supabase_client.dart';
import '../models/sale_model.dart';

class SalesService {

  Future<void> createSale(
    SaleModel sale,
  ) async {

    await supabase
        .from('sales')
        .insert(sale.toMap());
  }

  Future<List<Map<String, dynamic>>>
      fetchSales() async {

    final response =
        await supabase
            .from('sales')
            .select()
            .order(
              'created_at',
              ascending: false,
            );

    return List<Map<String, dynamic>>
        .from(response);
  }
}