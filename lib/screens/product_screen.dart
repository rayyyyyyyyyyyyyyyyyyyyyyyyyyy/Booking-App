// import 'package:flutter/material.dart';
// // import 'detail_product_screen.dart';

// import '../data/product.dart';
// import '../service/api_service.dart';

// class ProductScreen extends StatelessWidget {
//   const ProductScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Fake store product"),),
//       body: FutureBuilder<List<Product>>(
//         future: ApiService.fetchProduct(),
//         builder: (context, snapshot){

//           if(snapshot.connectionState == ConnectionState.waiting){
//             return const Center(child: CircularProgressIndicator(),);
//           }

//           if (snapshot.hasError){
//             return Center(child: Text("Error: ${snapshot.error}"),);
//           }

//           final products = snapshot.data!;

//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (context, index){

//               final product = products[index];
             
//               return Card(
//                 margin: const EdgeInsets.all(10.0),
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => DetailProductScreen(product: product),                        ),
//                     );
//                   },
//                   leading: Image.network(product.image, width: 50, height: 50,),
//                   title: Text(product.title),
//                   subtitle: Text("\$${product.price}"),
//                   trailing: const Icon(Icons.arrow_forward_ios),
//                 ),
//               );

//             },
//           );

//         },
//         ),
//     );
//   }
// }





// class ProductScreen extends StatefulWidget {
//   const ProductScreen({super.key});

//   @override
//   State<ProductScreen> createState() => _ProductScreenState();
// }

// class _ProductScreenState extends State<ProductScreen> {
//   // ข้อมูลจำลอง (Mock Data) ตรงส่วนนี้สามารถลบออกได้เมื่อเชื่อมต่อกับ API จริง
//   final List<Product> products = [
//     Product(
//       name: 'Grand Royal Hotel',
//       location: 'Bangkok, Thailand',
//       price: 120,
//       rating: 4.5,
//       image:
//           "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500&q=80",
//       category: 'Luxury',
//       inStock: true,
//     ),
//     Product(
//       name: 'Sunset Beach Resort',
//       location: 'Phuket, Thailand',
//       price: 250,
//       rating: 4.8,
//       image:
//           "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=80",
//       category: 'Beachfront',
//       inStock: true,
//     ),
//     Product(
//       name: 'Cozy Mountain Cabin',
//       location: 'Chiang Mai, Thailand',
//       price: 80,
//       rating: 4.3,
//       image:"https://images.pexels.com/photos/147411/italy-mountains-dawn-daybreak-147411.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
//       category: 'Villa',
//       inStock: true,
//     ),
//     Product(
//       name: 'Urban City Loft',
//       location: 'Singapore',
//       price: 180,
//       rating: 4.7,
//       image:
//           "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500&q=80",
//       category: 'City Center',
//       inStock: true,
//     ),
//   ];

//   final List api_product = [];
//   final bool isloading = true;

//   Future<void> fetchProducts() async {
//     final response = await http.get(
//       Uri.parse('https://api.example.com/products'),
//     );
//     if (response.statusCode == 200) {
//       final List data = json.decode(response.body);
//       setState(() {
//         api_product.clear();
//         api_product.addAll(data);
//       });
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Available Stays"), centerTitle: true),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16), // เพิ่มระยะห่างขอบจอ
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];

//           return Card(
//             elevation: 4, // เพิ่มเงาให้การ์ด
//             margin: const EdgeInsets.only(bottom: 16), // ระยะห่างระหว่างการ์ด
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Column(
//               children: [
//                 // 1. ส่วนรูปภาพ
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(15),
//                   ),
//                   child: Image.network(
//                     product.image,
//                     height: 180, // กำหนดความสูงรูป
//                     width: double.infinity,
//                     fit: BoxFit.cover, // ให้รูปเต็มกรอบสวยงาม
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       height: 180,
//                       color: Colors.grey[300],
//                       child: const Icon(Icons.broken_image),
//                     ),
//                   ),
//                 ),

//                 // 2. ส่วนข้อมูล
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ชื่อโรงแรม และ ราคา
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               product.name,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Text(
//                             "\$${product.price}",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 8),

//                       // สถานที่ (Location)
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             product.location,
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 8),

//                       // ดาว (Rating) และ ปุ่มจอง
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.star,
//                                 size: 20,
//                                 color: Colors.amber,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 "${product.rating} (${product.category})",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           // ปุ่มสถานะ (Book Now หรือ Sold Out)
//                           product.inStock
//                               ? ElevatedButton(
//                                   onPressed: () {
//                                     // กดจอง
//                                     print("Booking ${product.name}");
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blue,
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                   child: const Text("Book Now"),
//                                 )
//                               : const Chip(
//                                   label: Text("Sold Out"),
//                                   backgroundColor: Colors.grey,
//                                 ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
