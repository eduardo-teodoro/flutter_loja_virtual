import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/orders_tab.dart';
import 'package:loja_virtual/tabs/places_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //controlador para controlar a pagina que está sendo exibida
    final _pageController = PageController();


    //para navegar entre as páginas
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          //menu a esquerda do app
          drawer:CustomDrawer(_pageController) ,
          floatingActionButton: CartButton(),
        ),
        //outras paginas
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),

          body: ProductsTab(),
          floatingActionButton: CartButton(),

        ),
        //LOJAS
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),

        ),
        //MEUS PEDIDOS
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),

        )


      ],
    );
  }
}

