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

// class Product {
//   final String title;
//   final double price;
//   final String description;
//   final String category;
//   final String image;
//   final double rating;
//   final double rate;
//   final double count;

//   Product({
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.category,
//     required this.image,
//     required this.rating,
//     required this.rate,
//     required this.count,
//   });


 

  // เพิ่มส่วนนี้: สำหรับแปลง JSON จาก API เป็น Object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      // แปลงเป็น double เพื่อป้องกัน error
      price: (json['price'] ?? 0).toDouble(), 
      rating: (json['rating'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? 'General',
      inStock: json['inStock'] ?? false,
    );
  }
}

//   // สำหรับแปลง JSON จาก API เป็น Object
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       title: json['title'] ?? '',
//       price: (json['price'] ?? 0).toDouble(),
//       description: json['description'] ?? '',
//       category: json['category'] ?? 'General',
//       image: json['image'] ?? '',
//       rating: (json['rating'] ?? 0.0).toDouble(),
//       rate: (json['rate'] ?? 0.0).toDouble(),
//       count: (json['count'] ?? 0.0).toDouble(),
//     );
//   }
// }
