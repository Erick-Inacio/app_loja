import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  //para controlar a navegação entre páginas
  final PageController pageController;
  //para saber qual página é qual
  final int page;

  const DrawerTile(
    this.icon,
    this.text,
    this.pageController,
    this.page, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // MAterial() serve para adicionar efeitos aos clicar
    return Material(
      color: Colors.transparent,
      //InkWell é um efeito do Material()
      child: InkWell(
        onTap: () {
          //para fechar o drawer quando selecionar uma página
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32,
                color: pageController.page!.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
              const SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: pageController.page!.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
