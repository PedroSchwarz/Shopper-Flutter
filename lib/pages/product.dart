import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/products/price_tag.dart';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final double price;

  ProductPage(this.title, this.image, this.description, this.price);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(image),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TitleDefault(title)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 25.0),
                  child: Divider(height: 2.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Union Square, San Francisco'),
                    PriceTag(price)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Text(description,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                )
              ])),
    );
  }
}
