import 'package:scoped_model/scoped_model.dart';

import './connected_products.dart';
import './products.dart';
import './user.dart';

class MainModel extends Model with ConnectedProductsModel, UserModel, ProductsModel{

}