//classe para armazenar um produto do carrinho
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct{

  String cid;
  //categoria do produto
  String category;
  //piddo produto
  String pid;
  // Quantidade
  int quantity;
  //Tamanho
  String size;
  ProductData productData;

  //Construtor vazio
  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity =document.data["quantity"];
    size = document.data["size"];
  }

  Map<String, dynamic> toMap(){
      return{
        "category":category,
        "pid":pid,
        "quantity":quantity,
        "size":size,
        "product": productData.toResumedMap()


      };
  }

}