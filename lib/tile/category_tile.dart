import 'package:app_loja/screen/category_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snap;

  const CategoryTile({required this.snap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // o que vai no canto esquerdo do ListTile
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(
          (snap.data() as Map<String, dynamic>)['icon'],
        ),
      ),
      title: Text(
        (snap.data() as Map<String, dynamic>)['title'],
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryScreen(snap: snap),
          ),
        );
      },
    );
  }
}
