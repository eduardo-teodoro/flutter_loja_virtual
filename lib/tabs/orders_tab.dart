import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //verificando se está logado
    if (UserModel.of(context).isLoggedIn()) {
      //obtendo o id do usuário logado
      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("users")
            .document(uid)
            .collection("orders")
            .getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else{
            //exibindo a lista de pedidos
            return ListView(
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList().reversed.toList(),

            );

          }
        },
      );
    } else {
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
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            //espaçamento na vertical
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Faça o login para acompanhar!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                })
          ],
        ),
      );
    }
  }
}
