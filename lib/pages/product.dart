import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/price_tag.dart';
import '../widgets/ui_elements/title_default.dart';

import '../models/Product.dart';
import '../scoped_models/main.dart';

class ProductPage extends StatelessWidget {
  final int index;

  ProductPage(this.index);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Text('Union Square, San Francisco'), PriceTag(price)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.getProducts[index];
      return Scaffold(
          appBar: AppBar(title: Text(product.title)),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(product.image),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TitleDefault(product.title)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 25.0),
                  child: Divider(height: 2.0),
                ),
                _buildAddressPriceRow(product.price),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Text(product.description,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                )
              ]));
    }));
  }
}
