import 'package:flutter/material.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/product_edit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shopper App Flutter',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
//      home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(_products),
          '/admin': (BuildContext context) => ProductsAdminPage(
                _products,
                _addProduct,
                _deleteProduct,
              ),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            int _index;
            if (pathElements[2] == 'edit') {
              _index = int.parse(pathElements[3]);
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProductEditPage(_products[_index]));
            } else {
              _index = int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => ProductPage(
                      _products[_index]['title'],
                      _products[_index]['image'],
                      _products[_index]['description'],
                      _products[_index]['price']));
            }
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_products));
        });
  }
}
