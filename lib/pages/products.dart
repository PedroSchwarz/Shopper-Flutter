import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../widgets/ui_elements/adaptive_progress_indicator.dart';

import '../scoped_models/main.dart';

class ProductsPage extends StatefulWidget {
  final String title;
  final MainModel model;

  ProductsPage(this.model, {this.title = 'Shopper App Flutter'});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    widget.model.fetchProducts();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      AppBar(title: Text('Choose'), automaticallyImplyLeading: false),
      ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          }),
      Divider(height: 2.0),
      LogoutListTile()
    ]));
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No Products Found!'));
      if (model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(child: AdaptiveProgressIndicator());
      }
      return RefreshIndicator(child: content, onRefresh: model.fetchProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                });
          })
        ]),
        drawer: _buildSideDrawer(context),
        body: _buildProductsList());
  }
}
