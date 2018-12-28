import 'package:flutter/material.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;

  ProductCard(this.product, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Image.asset(product['image']),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        TitleDefault(product['title']),
        PriceTag(product['price'])
      ]),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: Divider(height: 2.0),
      ),
      Text('Union Square, San Francisco'),
      ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
            icon: Icon(Icons.info_outline, color: Colors.blue, size: 30.0),
            onPressed: () =>
                Navigator.pushNamed<bool>(context, '/product/$index')),
        IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.red, size: 30.0),
            onPressed: () {}),
      ])
    ]));
  }
}
