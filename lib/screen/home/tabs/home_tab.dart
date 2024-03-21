// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    //Criando um fundo de Container degradê
    Widget buildBodyBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xfffb6f92),
                Color(0xffffb3c6),
                Color(0xffffc2d1),
              ],
              //definando aonde começa o degradê
              begin: Alignment.topLeft,
              //e aonde termina
              end: Alignment.bottomRight,
            ),
          ),
        );

    /* Stack serve para que o conteúdo fique acima do fundo criado,
    no caso, o degradê */
    return Stack(
      children: <Widget>[
        buildBodyBack(),
        //ScrollView customizado
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              //efeito da barra
              snap: true,
              backgroundColor: Colors.transparent,
              //elevação da barra em relação ao conteúdo
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Novidades',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            //Aqui iremos construir um widget q depende de uym dado futuro via BD
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('home')
                  .orderBy('pos')
                  .get(),
              builder: (context, snapshot) {
                //Verificando se os dados ainda estão sendo carregados
                if (!snapshot.hasData) {
                  // por conta do customScrollView, precisa colocar widgets slivers e n os normais
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                  // caso os dados estejam disponíveis
                } else {
                  //Aqui, pegamos a lista de docs quando obtivermos os dados
                  var documents = snapshot.data!.docs;

                  //widget q irá criar a grid para o customScrollView
                  return SliverGrid(
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      pattern: List.generate(documents.length, (index) {
                        //Aqui será ajustado o tamanho baseado nos campos x e y do documento no firebase
                        var doc = documents[index];
                        int x = doc['x'];
                        int y = doc['y'];
                        return QuiltedGridTile(x, y);
                      }),
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var doc = documents[index];
                      String image = doc['image'];

                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: image,
                        fit: BoxFit.cover,
                      );
                    }, childCount: documents.length),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
