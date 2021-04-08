import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //usuario logado
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  //para conseguir acessar de todas as classes o user model
static UserModel of(BuildContext context) =>
    ScopedModel.of<UserModel>(context);


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurretUser();
  } //usuario atual
  //userdata são os dados do usuário
  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      //se der tudo certo o firebaseuser recebe o usuário
      firebaseUser = user;
      //para salver o endereço e nome do usuário
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

//fazer logindo usuário
  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) async {
      firebaseUser = user;
      //
      await _loadCurretUser();
      //
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });

    // await Future.delayed(Duration(seconds: 3));
    // isLoading = false;
    // notifyListeners();
  }

  //fazer logout do app
  void signOut() async {
    await _auth.signOut();
    //resetando o mapa
    userData = Map();
    firebaseUser = null;
    //notificando todos os listeners informando que o usuário foi modificado
    notifyListeners();
  }

//recuperar senha
  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  //função informando que está logado
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurretUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
            userData = docUser.data;
      }
      notifyListeners();
    }
  }
}
