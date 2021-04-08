import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  //para controlar o drawer, recebera um construtor

  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          //lista de itens dentro do menu
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                //para posicionar as informações
                child: Stack(
                  children: [
                    //titulo
                    Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Text(
                          "Flutter\n Clothing",
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold),
                        )),
                    //textos olá e Entre e cadastre-se
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model){
                            return Column(
                              //alinhamento
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                //para pegar o click
                                GestureDetector(
                                  child: Text(
                                    !model.isLoggedIn() ?
                                    "Entre ou cadastre-se >"
                                    :
                                    "Sair",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    //se não estiver logado pede para entrar ou cadastrar
                                    if(!model.isLoggedIn() )
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => LoginScreen())
                                    );
                                    else
                                      //se estiver logado pede para sair
                                      model.signOut();
                                  },
                                )
                              ],
                            );
                          },
                        )

                          

                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController,0),
              DrawerTile(Icons.list, "Produtos", pageController,1),
              DrawerTile(Icons.location_on, "Encontre uma Loja", pageController,2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", pageController,3),

            ],
          )
        ],
      ),
    );
  }
}
