import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      //ao trocar de usuário o carrinho é refeito
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            //passando o user model como parâmetro
            model: CartModel(model),
            child: MaterialApp(
              title: "Flutter's Cothing",
              theme: ThemeData(

                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141),

                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        },

      )
    );

  }
}
