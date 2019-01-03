import 'package:scoped_model/scoped_model.dart';

import '../models/Product.dart';
import '../models/User.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;

  void addProduct(
      String title, String description, double price, String image) {
    final Product newProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email);
    _products.add(newProduct);
  }

  void updateProduct(
      String title, String description, double price, String image, int index) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email);
    _products[index] = updatedProduct;
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

  void deleteProduct(int index) {
    _products.removeAt(index);
  }

  void toggleProductFavoriteStatus(int index) {
    final Product currentProduct = _products[index];
    final bool currentStatus = currentProduct.isFavorite;
    final bool newFavoriteStatus = !currentStatus;
    final Product updatedProduct = Product(
        title: currentProduct.title,
        description: currentProduct.description,
        price: currentProduct.price,
        image: currentProduct.image,
        userId: currentProduct.userId,
        userEmail: currentProduct.userEmail,
        isFavorite: newFavoriteStatus);
    _products[index] = updatedProduct;
    notifyListeners();
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
