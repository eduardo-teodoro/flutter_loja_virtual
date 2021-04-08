import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  //Usuário atual
  UserModel user;

  //Lista que conterá todos os produtos do carrinho
  List<CartProduct> products = [];

  String cuponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  //construtor
  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  //Para conseguir acessar o cart Model de todas as classes
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  //função para adicionar um novo produto no carrinho
  void addCartItem(CartProduct cartProduct) {
    //adicionando ao carrinho
    products.add(cartProduct);
    //adicionando ao banco de dados no firebase
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });
    notifyListeners();
  }

  //função para remover um novo produto no carrinho
  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  //decrementar a quantidade no pedido
  void decProduct(CartProduct cartProduct) {
    //atualizando quantidade
    cartProduct.quantity--;
    //atualizandoo Firestore
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    //
    notifyListeners();
  }

  //incluir a quantidade no pedido
  void incProduct(CartProduct cartProduct) {
    //atualizando quantidade
    cartProduct.quantity++;
    //atualizandoo Firestore
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    //
    notifyListeners();
  }

  //aplicando desconto do carrinho
  void setCoupon(String couponCode, int discountPercentage) {
    this.cuponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  //para atualizar os valores assim que a tela do carrinho for carregada
  void updatePrices() {
    notifyListeners();
  }

  //retornando o subtotal
  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += c.quantity * c.productData.price;

    }
    return price;
  }

  //retorna o denconto
  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  //retorna o valor da entrega
  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    //verificando se a lista de produtos esta vazia
    if (products.length == 0) return null;

    //informando que está processando
    isLoading = true;

    //atualiza a tela para que o prograssbar apareça
    notifyListeners();

    //pegando os tres preços
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    //criando o pedido no firebase
    DocumentReference refOrder =
        await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      //transformando lista de produtos em uma lista de mapas
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      //status do pedido
      "status": 1
    });

    //salvando o numero de pedido no usuário
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(refOrder.documentID)
        .setData({"orderId": refOrder.documentID});

    //removendo os produtos do carrinho
    //pegando todos os produtos do carrinho
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }
    //limpando a lista local

    products.clear();
    cuponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();
    return refOrder.documentID;

  }


  //recuperando os itens do carrinho
  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    //configurando lista de produtos. Mapeando cada produto
    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }


}
