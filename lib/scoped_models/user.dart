import '../models/User.dart';
import './connected_products.dart';

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    authenticatedUser = User(id: 'userUid', email: email, password: password);
  }
}
