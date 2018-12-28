import 'package:flutter/material.dart';

import '../widgets/products/products.dart';

class ProductsPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  ProductsPage(this.products, {this.title = 'Shopper App Flutter'});

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      AppBar(title: Text('Choose'), automaticallyImplyLeading: false),
      ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          })
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.favorite), onPressed: () {})
          ],
        ),
        drawer: _buildSideDrawer(context),
        body: Products(products));
  }
}
