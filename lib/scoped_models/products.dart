import 'package:scoped_model/scoped_model.dart';

import '../models/Product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;

  List<Product> get products {
    return List.from(_products);
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

  void selectedProduct(int index) {
    _selectedProductIndex = index;
  }
}
