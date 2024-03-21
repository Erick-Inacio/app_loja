import 'package:app_loja/data/product_data.dart';
import 'package:app_loja/tile/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snap;

  const CategoryScreen({required this.snap, super.key});

  @override
  Widget build(BuildContext context) {
    //Widget que controlará a tab navigator
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text((snap.data() as Map<String, dynamic>)['title']),
          centerTitle: true,
          //Começando a contrução da TabBar
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            //Dicionando as Tabs
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.grid_on,
                ),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        //no body do scaffold entra o que será exibido ao clicar em cada tab
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('products')
              .doc(snap.id)
              .collection('items')
              .get(),
          builder: ((context, snap) {
            if (!snap.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  //widget estilo Grid para alterar pela tab
                  GridView.builder(
                    padding: const EdgeInsets.all(4),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context, index) {

                      ProductData data = ProductData.fromDoc(
                        snap.data!.docs[index],
                      );

                      data.category = this.snap.id;
                      return ProductTile(type: 'grid', product: data);
                    },
                  ),
                  //widget estiloList para alterar pela tab
                  ListView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context, index) {

                      ProductData data = ProductData.fromDoc(
                        snap.data!.docs[index],
                      );
                      
                      data.category = this.snap.id;

                      return ProductTile(
                        type: 'list',
                        product: data,
                      );
                    },
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
