import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/product_edit.dart';

import './scoped_models/main.dart';

void main() {
  MapView.setApiKey("AIzaSyDLEA0qtBHOyXYr9-EdnWVExivlCI1uyD0");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          title: 'Shopper App Flutter',
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          debugShowCheckedModeBanner: false,
//      home: AuthPage(),
          routes: {
            '/': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductsPage(_model),
            '/admin': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute(
                  builder: (BuildContext context) => AuthPage());
            }
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            String _id;
            if (pathElements[1] == 'product') {
              if (pathElements[2] == 'edit') {
                _id = pathElements[3];
                return MaterialPageRoute(
                    builder: (BuildContext context) =>
                        !_isAuthenticated ? AuthPage() : ProductEditPage(_id));
              } else {
                _id = pathElements[2];
                return MaterialPageRoute<bool>(
                    builder: (BuildContext context) =>
                        !_isAuthenticated ? AuthPage() : ProductPage(_id));
              }
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : ProductsPage(_model));
          }),
    );
  }
}
