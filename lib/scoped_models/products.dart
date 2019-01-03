import '../models/Product.dart';
import './connected_products.dart';

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get getProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    return _showFavorites
        ? products.where((Product product) => product.isFavorite).toList()
        : List.from(products);
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void deleteProduct(int index) {
    products.removeAt(index);
  }

  void toggleProductFavoriteStatus(int index) {
    final Product currentProduct = products[index];
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
    products[index] = updatedProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
