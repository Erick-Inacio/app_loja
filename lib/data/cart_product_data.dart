import 'package:app_loja/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  late String cid;

  late String category;
  late String pid;

  late int quantity;
  late String size;

  late ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot snap) {
    cid = snap.id;
    category = (snap.data() as Map<String, dynamic>)['category'];
    pid = (snap.data() as Map<String, dynamic>)['pid'];
    quantity = (snap.data() as Map<String, dynamic>)['quantity'];
    size = (snap.data() as Map<String, dynamic>)['size'];
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      // 'product': productData.toResumeMap(),
    };
  }
}
