import 'package:app_loja/data/cart_product_data.dart';
import 'package:app_loja/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  CartModel(this.user);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cart) {
    products.add(cart);

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.user!.uid)
        .collection('cart')
        .add(cart.toMap())
        .then(
      (doc) {
        cart.cid = doc.id;
      },
    );

    notifyListeners();
  }

  void removeCardItem(CartProduct cart) {
    products.remove(cart);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .doc(cart.cid)
        .delete();

    products.remove(cart);
    notifyListeners();
  }
}
