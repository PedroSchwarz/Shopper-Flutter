import 'package:flutter/material.dart';

import './product_create.dart';
import './product_list.dart';

class ProductsAdminPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function addProduct;
  final Function deleteProduct;

  ProductsAdminPage(this.products, this.addProduct, this.deleteProduct);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      AppBar(title: Text('Choose'), automaticallyImplyLeading: false),
      ListTile(
          leading: Icon(Icons.shop),
          title: Text('All Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/products');
          })
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Manage Products'),
                bottom: TabBar(tabs: <Widget>[
                  Tab(text: 'Create Product', icon: Icon(Icons.create)),
                  Tab(text: 'My Products', icon: Icon(Icons.list))
                ])),
            drawer: _buildSideDrawer(context),
            body: TabBarView(children: <Widget>[
              ProductCreatePage(addProduct),
              ProductListPage(products)
            ])));
  }
}
