import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Product.dart';
import '../models/User.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Null> addProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> newData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://ifoodreal.com/wp-content/uploads/2017/09/FG-cheese-pizza-cauliflower-pizza-crust-recipe.jpg',
      'userId': _authenticatedUser.id,
      'userEmail': _authenticatedUser.email,
      'isFavorite': false
    };
    return http
        .post('https://shopper-flutter-41f06.firebaseio.com/products.json',
            body: json.encode(newData))
        .then((http.Response res) {
      _isLoading = false;
      final Map<String, dynamic> resData = json.decode(res.body);
      final Product newProduct = Product(
          id: resData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email);
      _products.add(newProduct);
      notifyListeners();
    });
  }

  Future<Null> updateProduct(
      String title, String description, double price, String image, String id) {
    _isLoading = true;
    notifyListeners();
    final Product currentProduct =
        _products.firstWhere((Product product) => product.id == id);
    final int currentProductIndex = _products.indexOf(currentProduct);
    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://ifoodreal.com/wp-content/uploads/2017/09/FG-cheese-pizza-cauliflower-pizza-crust-recipe.jpg',
      'isFavorite': currentProduct.isFavorite,
      'userId': currentProduct.userId,
      'userEmail': currentProduct.userEmail
    };
    return http
        .put('https://shopper-flutter-41f06.firebaseio.com/products/$id.json',
            body: json.encode(updatedData))
        .then((http.Response res) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: currentProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          isFavorite: currentProduct.isFavorite,
          userId: currentProduct.userId,
          userEmail: currentProduct.userEmail);
      _products[currentProductIndex] = updatedProduct;
      notifyListeners();
    });
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get getProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    return _showFavorites
        ? _products.where((Product product) => product.isFavorite).toList()
        : List.from(_products);
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void deleteProduct(String id) {
    final int deletedProductIndex =
        _products.indexWhere((product) => product.id == id);
    http
        .delete(
            'https://shopper-flutter-41f06.firebaseio.com/products/$id.json')
        .then((http.Response res) {
      _products.removeAt(deletedProductIndex);
      notifyListeners();
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://shopper-flutter-41f06.firebaseio.com/products.json')
        .then((http.Response res) {
      _isLoading = false;
      final List<Product> products = [];
      final Map<String, dynamic> productsList = json.decode(res.body);
      if (productsList == null) {
        notifyListeners();
        return;
      }
      productsList.forEach((String id, dynamic productData) {
        final Product product = Product(
            id: id,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userId: productData['userId'],
            userEmail: productData['userEmail'],
            isFavorite: productData['isFavorite']);
        products.add(product);
      });
      _products = products;
      notifyListeners();
    });
  }

  Product fetchSingleProduct(String id) {
    return _products.firstWhere((Product product) => product.id == id);
  }

  void toggleProductFavoriteStatus(String id) {
    final Product currentProduct =
        _products.firstWhere((Product product) => product.id == id);
    final int currentProductIndex = _products.indexOf(currentProduct);
    final bool currentStatus = currentProduct.isFavorite;
    final bool newFavoriteStatus = !currentStatus;
    final Map<String, dynamic> updatedData = {
      'title': currentProduct.title,
      'description': currentProduct.description,
      'price': currentProduct.price,
      'image': currentProduct.image,
      'userId': currentProduct.userId,
      'userEmail': currentProduct.userEmail,
      'isFavorite': newFavoriteStatus
    };
    http
        .put(
            'https://shopper-flutter-41f06.firebaseio.com/products/${currentProduct.id}.json',
            body: json.encode(updatedData))
        .then((http.Response res) {
      final Product updatedProduct = Product(
          id: currentProduct.id,
          title: currentProduct.title,
          description: currentProduct.description,
          price: currentProduct.price,
          image: currentProduct.image,
          userId: currentProduct.userId,
          userEmail: currentProduct.userEmail,
          isFavorite: newFavoriteStatus);
      _products[currentProductIndex] = updatedProduct;
      notifyListeners();
    });
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'userUid', email: email, password: password);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
