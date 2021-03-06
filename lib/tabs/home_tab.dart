import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // fundo degrade
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
                  //inicioda aplicação da cor
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        );

    return Stack(
      children: [
        _buildBodyBack(),
        //ScrollView customizado
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              //quando arrastar para baixo a barra irá sumir
              snap: true,
              //cor de fundo
              backgroundColor: Colors.transparent,
              //para que a barra não fique elevada e sim no mesmo plano do conteudo
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .getDocuments(),
              builder: (context, snapshot) {
                //se o snapshot não possui dado
                if (!snapshot.hasData)
                  //colocando um circleprogressindicator
                  //tem que colocar componente do tipo sliver porque está
                  // dentro de um customScrollView
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else
                  //Se usa o count para carregar as imagens de uma só vez
                  return SliverStaggeredGrid.count(
                    //1ª Parte transformando as imagens em StaggeredTile
                    //qtde de blocas na horizontal
                    crossAxisCount: 2,
                    //espaçamento entre as imagens
                    //vertival
                    mainAxisSpacing: 1.0,
                    //horizontal
                    crossAxisSpacing: 1.0,
                    //dimensões das tails
                    staggeredTiles: snapshot.data.documents.map(
                        //para cada documento na lista sera executado as instruções abaixo
                        (doc) {
                      //recebe como parâmetro as dimensões em X e Y
                      return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                    } //transformando o mapa em uma lista
                        ).toList(),
                    //2ª parte inserindo as imagens na tela
                    children:snapshot.data.documents.map(
                        (doc){
                          //exibir imagem suavemente
                          return FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: doc.data["image"],
                              //cobindo  o espaço possivel na tail
                              fit: BoxFit.cover,
                          );
                        }
                    ).toList(),
                  );
              },
            ),
          ],
        )
      ],
    );
  }
}
