import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String imagePath;
  final bool isFavorite;
  final String userId;
  final String userEmail;
  final Map<String, dynamic> wishlistUsers;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      @required this.imagePath,
      @required this.userId,
      @required this.userEmail,
      this.isFavorite = false,
      this.wishlistUsers});
}
