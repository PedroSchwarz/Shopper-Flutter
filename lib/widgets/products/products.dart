import 'package:flutter/material.dart';

import './price_tag.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(children: <Widget>[
      Image.asset(products[index]['image']),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(products[index]['title'],
            style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald')),
        PriceTag(products[index]['price'])
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

  Widget _buildProductsList() {
    Widget productCard = Center(child: Text('No Products Added Yet!'));
    if (products.length > 0) {
      productCard = ListView.builder(
          itemBuilder: _buildProductItem, itemCount: products.length);
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductsList();
  }
}
