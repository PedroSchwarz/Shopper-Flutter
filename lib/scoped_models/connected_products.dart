import 'package:scoped_model/scoped_model.dart';

import '../models/Product.dart';
import '../models/User.dart';

mixin ConnectedProductsModel on Model {
  List<Product> products = [];
  User authenticatedUser;

  void addProduct(
      String title, String description, double price, String image) {
    final Product newProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userId: authenticatedUser.id,
        userEmail: authenticatedUser.email);
    products.add(newProduct);
  }


  void updateProduct(String title, String description, double price, String image, int index) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userId: authenticatedUser.id,
        userEmail: authenticatedUser.email);
    products[index] = updatedProduct;
  }
}
