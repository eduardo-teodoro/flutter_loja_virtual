import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  //vai receber um productdata e o tipo
  final String type;
  final ProductData product;

  const ProductTile(this.type, this.product);

  //construtor

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        //abrindo tela de produto com um produto especifico
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> ProductScreen(product) )
        );

      },
      child: Card(
        child: type == "grid"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      product.images[0],
                      //para preencher  o espaço
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "R\$ ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ))
                ],
              )
            : Row(
          children: [
            Flexible(
              //divide a tela com o Flexible debaixo
              flex: 1,
                child: Image.network(
                  product.images[0],
                  //para preencher   o espaço
                  fit: BoxFit.cover,
                  height: 250.0,
                )
            ),
            Flexible(
              flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "R\$ ${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
