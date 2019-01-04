import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/product_edit.dart';

import './scoped_models/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
          title: 'Shopper App Flutter',
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          debugShowCheckedModeBanner: false,
//      home: AuthPage(),
          routes: {
            '/': (BuildContext context) => AuthPage(),
            '/products': (BuildContext context) => ProductsPage(model),
            '/admin': (BuildContext context) => ProductsAdminPage(model),
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
                    builder: (BuildContext context) => ProductEditPage(_index));
              } else {
                _index = int.parse(pathElements[2]);
                return MaterialPageRoute<bool>(
                    builder: (BuildContext context) => ProductPage(_index));
              }
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => ProductsPage(model));
          }),
    );
  }
}
