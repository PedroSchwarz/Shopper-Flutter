import 'package:scoped_model/scoped_model.dart';

import '../models/User.dart';

class UserModel extends Model {
  User _authenticatedUser;

  void login(String email, String password) {
    _authenticatedUser = User(id: null, email: email, password: password);
  }
}
