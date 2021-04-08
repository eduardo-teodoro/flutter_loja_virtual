import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/category_screen.dart';
class CategoryTile extends StatelessWidget {

  //recebe a categoria e o icone
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);



  @override
  Widget build(BuildContext context) {

    return ListTile(
      //icone que fica na esquerda
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text( snapshot.data["title"]),
      //sinal de maior na direita
      trailing: Icon (Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder:  (context) =>CategoryScreen(snapshot))

        );
      },

    );



  }
}
