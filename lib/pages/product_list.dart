import 'package:flutter/material.dart';

import '../models/Product.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function deleteProduct;

  ProductListPage(this.products, this.deleteProduct);

  void _buildShowAlertDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete Product'),
              content: Text('Are you sure?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('CANCEL')),
                FlatButton(
                    onPressed: () {
                      deleteProduct(index);
                      Navigator.of(context).pop();
                    },
                    child: Text('CONFIRM'))
              ]);
        });
  }

  Widget _buildEditButton(BuildContext context, int index) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => Navigator.pushNamed(context, '/product/edit/$index'));
  }

  Widget _buildProductsList() {
    return products.length > 0
        ? ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(products[index].title),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    _buildShowAlertDialog(context, index);
                  }
                },
                background: Container(color: Colors.red),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: CircleAvatar(
                            backgroundImage: AssetImage(products[index].image)),
                        title: Text(products[index].title),
                        subtitle: Text('\$ ${products[index].price.toString()}',
                            style: TextStyle(color: Colors.green)),
                        trailing: _buildEditButton(context, index)),
                    Divider(height: 2.0)
                  ],
                ),
              );
            })
        : Center(child: Text('No products added to your list yet!'));
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductsList();
  }
}
