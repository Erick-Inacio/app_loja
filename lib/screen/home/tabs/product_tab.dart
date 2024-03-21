import 'package:app_loja/tile/category_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          //criando uma var para colocar divisão entre as tiles
          var dividedTiles = ListTile.divideTiles(
                  //aqui entram os dados da tile
                  tiles: snapshot.data!.docs.map(
                    (doc) {
                      return CategoryTile(snap: doc);
                    },
                  //precisa converter pra lista
                  ).toList(),
                  //cor da divisão e novamente converte pra lista
                  color: Colors.grey[500])
              .toList();
          return ListView(children: dividedTiles);
        }
      },
    );
  }
}
