import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';

import '../../models/Product.dart';
import '../../scoped_models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard(this.product);

  Widget _buildTitlePriceRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      TitleDefault(product.title),
      PriceTag(product.price)
    ]);
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
          icon: Icon(Icons.info_outline, color: Colors.blue, size: 30.0),
          onPressed: () =>
              Navigator.pushNamed<bool>(context, '/product/${product.id}')),
      ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 30.0),
            onPressed: () {
              model.toggleProductFavoriteStatus(product.id);
            });
      })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      FadeInImage(
          placeholder: AssetImage('assets/food.jpg'),
          image: NetworkImage(product.imageUrl),
          fit: BoxFit.cover,
          height: 300,
          width: MediaQuery.of(context).size.width),
      _buildTitlePriceRow(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: Divider(height: 2.0),
      ),
      Text('Union Square, San Francisco'),
      Text(product.userEmail),
      _buildActionButtons(context)
    ]));
  }
}
