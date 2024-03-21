import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category = '';
  late String id;

  late String title;
  late String description;

  late double price;

  late List images;
  late List sizes;

  ProductData.fromDoc(DocumentSnapshot snap) {
    id = snap.id;
    title = (snap.data() as Map<String, dynamic>)['title'];
    description = (snap.data() as Map<String, dynamic>)['description'];
    price = (snap.data() as Map<String, dynamic>)['price'] + 0.0;
    images = (snap.data() as Map<String, dynamic>)['images'];
    sizes = (snap.data() as Map<String, dynamic>)['sizes'];
  }

  Map<String, dynamic> toResumeMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
