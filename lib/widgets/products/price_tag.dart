import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final double price;

  PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(20.0)),
        child: Text('\$ ${price.toString()}',
            style: TextStyle(color: Colors.white, fontSize: 12.0)));
  }
}
