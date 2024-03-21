import 'package:app_loja/screen/home/tabs/home_tab.dart';
import 'package:app_loja/screen/home/tabs/product_tab.dart';
import 'package:app_loja/widget/custom_drower.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  //Controller q irá controlar a navegação de páginas
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    //PageView me permite trocar entre telas
    return PageView(
      controller: _pageController,
      //impede q as páginas possam ser trocadas arrastando pro lado
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: const HomeTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: const ProductsTab(),
        ),
        Container(
          color: Colors.yellow,
        ),
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.green,
        ),
      ],
    );
  }
}
