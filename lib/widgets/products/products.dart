import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';

import '../../models/Product.dart';
import '../../scoped_models/products.dart';

class Products extends StatelessWidget {
  Widget _buildProductsList(List<Product> products) {
    Widget productCard = Center(child: Text('No Products Added Yet!'));
    if (products.length > 0) {
      productCard = ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              ProductCard(products[index], index),
          itemCount: products.length);
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return _buildProductsList(model.displayedProducts);
    });
  }
}
