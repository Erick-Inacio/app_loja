import 'package:app_loja/models/user_model.dart';
import 'package:app_loja/screen/login_screen.dart';
import 'package:app_loja/tile/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  const CustomDrawer({required this.pageController, super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildDrawerBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color(0xfffb6f92),
                Color(0xffffb3c6),
                Color(0xffffc2d1),
                Colors.white,
              ],
              //definando aonde começa o degradê
              begin: Alignment.topCenter,
              //e aonde termina
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                /* Stack() é utilizado no lugar da Column() pois, com ele, você
                consegue escolher a posição de cada elemento no container */
                child: Stack(
                  children: <Widget>[
                    const Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        'Flutter\'s \nClothing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      //Gerenciador de estado
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Olá, ${!model.isLoggedIn() ? "" : model.userData['name']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                      ? "Entre ou cadastres-se ->"
                                      : "Sair",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: ((context) => const LoginScreen()),
                                      ),
                                    );
                                  } else {
                                    model.signOut();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Column(
                  children: <Widget>[
                    // Elementos do drawer
                    DrawerTile(
                      Icons.home,
                      'Início',
                      pageController,
                      0,
                    ),
                    DrawerTile(
                      Icons.list,
                      'Produtos',
                      pageController,
                      1,
                    ),
                    DrawerTile(
                      Icons.location_on,
                      'Lojas',
                      pageController,
                      2,
                    ),
                    DrawerTile(Icons.playlist_add_check, 'Meus Pedidos',
                        pageController, 3),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
