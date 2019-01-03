import 'package:scoped_model/scoped_model.dart';

import '../models/Product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  bool _showFavorites = false;

  List<Product> get products {
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

  void addProduct(Product product) {
    _products.add(product);
  }

  void updateProduct(Product product, int index) {
    _products[index] = product;
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
        isFavorite: newFavoriteStatus);
    _products[index] = updatedProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
