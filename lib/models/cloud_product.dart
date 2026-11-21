/// The API model is separate from the local SOLE Product used by earlier labs.
class Product {
  final int id, reviewCount;
  final String title, description, category, imageUrl;
  final double price, rating;
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    final reviews = json['rating'] is Map ? json['rating'] as Map : const {};
    double number(dynamic value) =>
        value is num && value.isFinite ? value.toDouble() : 0;
    String text(dynamic value, String fallback) =>
        value is String && value.trim().isNotEmpty ? value : fallback;
    return Product(
      id: number(json['id']).toInt(),
      title: text(json['title'], 'Untitled product'),
      price: json['price'] is num && (json['price'] as num).isFinite
          ? (json['price'] as num).toDouble()
          : 0,
      description: text(json['description'], 'No description available.'),
      category: text(json['category'], 'Uncategorized'),
      imageUrl: text(json['image'], ''),
      rating: number(reviews['rate']),
      reviewCount: number(reviews['count']).toInt(),
    );
  }
  String get deepLink => 'narxoz://store/product/$id';
}
