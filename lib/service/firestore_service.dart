import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/product_firestore.dart';

Stream<List<Product>> streamProducts() {
  return FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map((snap) => snap.docs.map(Product.fromFirestore).toList());
}