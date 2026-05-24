class SaleModel {

  final String id;

  final double subtotal;
  final double gst;
  final double discount;
  final double total;

  final String paymentMethod;

  final DateTime createdAt;

  SaleModel({
    required this.id,
    required this.subtotal,
    required this.gst,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'subtotal': subtotal,
      'gst': gst,
      'discount': discount,
      'total': total,
      'payment_method': paymentMethod,
      'created_at':
          createdAt.toIso8601String(),
    };
  }
}