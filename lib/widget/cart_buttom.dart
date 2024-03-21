import 'package:app_loja/screen/cart_screen.dart';
import 'package:flutter/material.dart';

class CartButtom extends StatelessWidget {
  const CartButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CartScreen(),
          ),
        );
      },
    );
  }
}
