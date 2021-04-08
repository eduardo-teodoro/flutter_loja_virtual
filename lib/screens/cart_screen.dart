/*
Tela do carrinho de compras
 */
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Scaffold para que a barra superior seja exibida
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho"),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            //o texto dependo do cartmodel par exibir a quantidade de itens no carrinho
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;

                return Text(
                  //se p nulo retorna 0 senão retorna p
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            //1- Se o model estiver carregando e o usuário estiver logado, apresenta a tela de carregando
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            //2- Se o usuario não estiver logado
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                //preenchendo o espaço possivel na horizontal
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //centralizando o conteudo na tela
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  //espaçamento na vertical
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Faça o login para adicionar produtos!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        //abrindo a logiScreen
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      })
                ],
              ),
            );
          } else if (model.products == null || model.products.length == 0) {
            //3- Se o carringo estiver vazio
            return Center(
              child: Text(
                "Nunhum produto no carrinho",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            //4- Tem produtos no carrinho e está logado
            return ListView(
              children: [
                Column(
                  //mapeando os produtos
                  children: model.products.map((product) {
                    return CartTile(product);
                  }).toList(),
                ),
                //desconto
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if (orderId != null)
                    //Substituido a tela do carrinho pela confirmação
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OrderScreen(orderId)));
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
