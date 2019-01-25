import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';

import '../models/Product.dart';
import '../models/User.dart';
import '../models/Auth.dart';
import '../models/LocationData.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  bool _isLoading = false;
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

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-shopper-flutter-41f06.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamRes = await imageUploadRequest.send();
      final res = await http.Response.fromStream(streamRes);
      if (res.statusCode != 200 && res.statusCode != 201) {
        return null;
      }
      final resData = json.decode(res.body);
      return resData;
    } catch (error) {
      return null;
    }
  }

  Future<bool> addProduct(
      String title, String description, double price, File image) async {
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      return false;
    }
    final Map<String, dynamic> newData = {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': uploadData['imageUrl'],
      'imagePath': uploadData['imagePath'],
      'userId': _authenticatedUser.id,
      'userEmail': _authenticatedUser.email
    };
    try {
      final http.Response res = await http.post(
          'https://shopper-flutter-41f06.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(newData));
      if (res.statusCode != 200 && res.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      final Map<String, dynamic> resData = json.decode(res.body);
      final Product newProduct = Product(
          id: resData['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email);
      _products.add(newProduct);
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String title, String description, double price,
      File image, String id) async {
    _isLoading = true;
    notifyListeners();
    final Product currentProduct =
        _products.firstWhere((Product product) => product.id == id);
    final int currentProductIndex = _products.indexOf(currentProduct);
    String imageUrl = currentProduct.imageUrl;
    String imagePath = currentProduct.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        return false;
      }
      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }
    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'userId': currentProduct.userId,
      'userEmail': currentProduct.userEmail,
      'wishlistUsers': currentProduct.wishlistUsers
    };
    try {
      await http.put(
          'https://shopper-flutter-41f06.firebaseio.com/products/$id.json?auth=${_authenticatedUser.token}',
          body: json.encode(updatedData));
      _isLoading = false;
      final Product updatedProduct = Product(
          id: currentProduct.id,
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl,
          imagePath: imagePath,
          isFavorite: currentProduct.isFavorite,
          wishlistUsers: currentProduct.wishlistUsers,
          userId: currentProduct.userId,
          userEmail: currentProduct.userEmail);
      _products[currentProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    final int deletedProductIndex =
        _products.indexWhere((product) => product.id == id);
    try {
      await http.delete(
          'https://shopper-flutter-41f06.firebaseio.com/products/$id.json?auth=${_authenticatedUser.token}');
      _products.removeAt(deletedProductIndex);
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchProducts({onlyForUser: false}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response res = await http.get(
          'https://shopper-flutter-41f06.firebaseio.com/products.json?auth=${_authenticatedUser.token}');
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
            imageUrl: productData['imageUrl'],
            imagePath: productData['imagePath'],
            userId: productData['userId'],
            userEmail: productData['userEmail'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id),
            wishlistUsers: productData['wishlistUsers']);
        products.add(product);
      });
      _products = onlyForUser
          ? products
              .where((product) => product.userId == _authenticatedUser.id)
              .toList()
          : products;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  Product fetchSingleProduct(String id) {
    return _products.firstWhere((Product product) => product.id == id);
  }

  void toggleProductFavoriteStatus(String id) async {
    final Product currentProduct =
        _products.firstWhere((Product product) => product.id == id);
    final int currentProductIndex = _products.indexOf(currentProduct);
    final bool currentStatus = currentProduct.isFavorite;
    final bool newFavoriteStatus = !currentStatus;
    final Product updatedProduct = Product(
        id: currentProduct.id,
        title: currentProduct.title,
        description: currentProduct.description,
        price: currentProduct.price,
        imageUrl: currentProduct.imageUrl,
        imagePath: currentProduct.imagePath,
        userId: currentProduct.userId,
        userEmail: currentProduct.userEmail,
        isFavorite: newFavoriteStatus);
    _products[currentProductIndex] = updatedProduct;
    notifyListeners();
    http.Response res;
    if (newFavoriteStatus) {
      res = await http.put(
          'https://shopper-flutter-41f06.firebaseio.com/products/$id/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      res = await http.delete(
          'https://shopper-flutter-41f06.firebaseio.com/products/$id/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (res.statusCode != 200 && res.statusCode != 201) {
      final Product updatedProduct = Product(
          id: currentProduct.id,
          title: currentProduct.title,
          description: currentProduct.description,
          price: currentProduct.price,
          imageUrl: currentProduct.imageUrl,
          imagePath: currentProduct.imagePath,
          userId: currentProduct.userId,
          userEmail: currentProduct.userEmail,
          isFavorite: currentStatus);
      _products[currentProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response res;
    if (mode == AuthMode.Login) {
      res = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDB5wpfMDvWYs5clK-tNc9C2X6Gq1vJBVA',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      res = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDB5wpfMDvWYs5clK-tNc9C2X6Gq1vJBVA',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }
    final Map<String, dynamic> resData = json.decode(res.body);
    bool hasSucceeded = true;
    String message = 'Authenticated succeeded.';
    if (resData.containsKey('error')) {
      hasSucceeded = false;
      switch (resData['error']['message']) {
        case 'EMAIL_EXISTS':
          message = 'This e-mail already exists.';
          break;
        case 'EMAIL_NOT_FOUND':
          message = 'This e-mail wasn\'t found.';
          break;
        case 'INVALID_PASSWORD':
          message = 'The password is invalid.';
          break;
        default:
          message = 'Something went wrong.';
          break;
      }
    } else {
      _authenticatedUser =
          User(id: resData['localId'], email: email, token: resData['idToken']);
      setAuthTimeout(int.parse(resData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(resData['expiresIn'])));
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setString('token', resData['idToken']);
      preferences.setString('email', email);
      preferences.setString('id', resData['localId']);
      preferences.setString('expiryTime', expiryTime.toIso8601String());
    }
    _isLoading = false;
    notifyListeners();
    return {'success': hasSucceeded, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');
    if (token != null) {
      final String email = preferences.getString('email');
      final String id = preferences.getString('id');
      final String expiryTime = preferences.getString('expiryTime');
      final DateTime now = DateTime.now();
      final DateTime parsedExpiryTime = DateTime.parse(expiryTime);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      setAuthTimeout(tokenLifespan);
      _authenticatedUser = User(id: id, email: email, token: token);
      _userSubject.add(true);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    preferences.remove('email');
    preferences.remove('id');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
