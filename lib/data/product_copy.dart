// class Product {
//   final double id;
//   final String title;
//   final double price;
//   final String description;
//   final String category;
//   final String image;
//   final double rating;
//   final double rate;
//   final double count;

//   Product({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.category,
//     required this.image,
//     required this.rating,
//     required this.rate,
//     required this.count,
//   });

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
