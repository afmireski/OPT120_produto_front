import 'package:flutter/material.dart';
import 'package:opt120_produto_front/src/models/products.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    var formated_price = product.price / 100;

    return Card(      
      child: ListTile(
        title: Text(
          product.description,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "R\$ ${formated_price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            print("Delete product");
          },
          icon: Icon(
            Icons.question_mark,
            color: Colors.grey[700],
          ),
          tooltip: "Mais detalhes",
        ),
      ),
    );
  }
}
