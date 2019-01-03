import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/Product.dart';
import '../scoped_models/main.dart';

class ProductListPage extends StatelessWidget {
  void _buildShowAlertDialog(
      BuildContext context, int index, Function deleteProduct) {
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

  Widget _buildProductsList(MainModel model) {
    final List<Product> products = model.getProducts;
    return products.length > 0
        ? ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(products[index].title),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    _buildShowAlertDialog(context, index, model.deleteProduct);
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
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductsList(model);
    });
  }
}
