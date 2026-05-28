class ProductModel {
  final String id;
  final String name;
  final String barcode;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      price: map['price'].toDouble(),
      stock: map['stock'],
      category: map['category'],
      imageUrl: map['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'price': price,
      'stock': stock,
      'category': category,
      'image_url': imageUrl,
    };
  }
}