class Product {
  Product({
    required this.platform,
    required this.price,
    required this.quantity,
    required this.title,
    this.imageUrl,
  });

  final String platform;
  final String title;
  final String quantity;
  final int price;
  String? imageUrl;
  String? productUrl;
}
