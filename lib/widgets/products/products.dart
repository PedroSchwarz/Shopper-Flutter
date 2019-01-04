import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';

import '../../models/Product.dart';
import '../../scoped_models/main.dart';

class Products extends StatelessWidget {
  Widget _buildProductsList(List<Product> products) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index]),
        itemCount: products.length);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductsList(model.displayedProducts);
    });
  }
}
