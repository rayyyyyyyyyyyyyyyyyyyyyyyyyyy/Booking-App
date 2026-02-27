// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../data/product_copy.dart';

// class ApiService {
//   static const String apiUrl = 'https://fakestoreapi.com/products';

//   static Future<List<Product>> fetchProducts() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => Product.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to load products');
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//       throw e;
//     }
//   }
// }
