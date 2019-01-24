import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/price_tag.dart';
import '../widgets/products/product_fab.dart';
import '../widgets/ui_elements/title_default.dart';

import '../models/Product.dart';
import '../scoped_models/main.dart';

class ProductPage extends StatelessWidget {
  final String id;

  ProductPage(this.id);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Text('Union Square, San Francisco'), PriceTag(price)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.fetchSingleProduct(id);
      return Scaffold(
          body: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
                expandedHeight: 400.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(product.title),
                    background: Hero(
                      tag: product.id,
                      child: FadeInImage(
                          placeholder: AssetImage('assets/food.jpg'),
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover),
                    ))),
            SliverList(
                delegate: SliverChildListDelegate([
              Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
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
                            fontSize: 18.0, fontWeight: FontWeight.bold)))
              ])
            ]))
          ]),
          floatingActionButton: ProductFAB(product));
    });
  }
}
