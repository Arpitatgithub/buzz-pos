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
}