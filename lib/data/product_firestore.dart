import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String location;
  final double price;
  final double rating;
  final String image;
  final String category;
  final bool inStock;

  Product({
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.image,
    required this.category,
    required this.inStock,
  });

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Missing data for productId: ${doc.id}');
    }

    return Product(
      name: (data['name'] ?? '') as String,
      location: (data['location'] ?? '') as String,
      price: ((data['price'] ?? 0) as num).toDouble(),
      rating: ((data['rating'] ?? 0) as num).toDouble(),
      inStock: (data['inStock'] ?? false) as bool,
      category: (data['category'] ?? '') as String,
      image: (data['image'] ?? '') as String,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'location': location,
        'price': price,
        'rating': rating,
        'inStock': inStock,
        'category': category,
        'image': image,
      };
}