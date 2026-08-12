import '../core/supabase_client.dart';
import '../models/sale_model.dart';
import '../models/cart_item_model.dart';

class SalesService {

  Future<void> createSale(
    SaleModel sale,
  ) async {

    await supabase
        .from('sales')
        .insert(
          sale.toMap(),
        );
  }


  Future<void> completeSale({
    required SaleModel sale,
    required List<CartItemModel> items,
  }) async {

    final currentUser =
        supabase.auth.currentUser;

    if (currentUser == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    final saleItems =
        items.map(
          (item) {
            return {
              'product_id':
                  item.product.id,

              'quantity':
                  item.quantity,
            };
          },
        ).toList();


    await supabase.rpc(
  'complete_sale',
  params: {
    'p_sale_id': sale.id,
    'p_cashier_id': currentUser.id,
    'p_subtotal': sale.subtotal,
    'p_gst': sale.gst,
    'p_discount': sale.discount,
    'p_total': sale.total,
    'p_payment_method': sale.paymentMethod,
    'p_items': saleItems,
  },
);
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