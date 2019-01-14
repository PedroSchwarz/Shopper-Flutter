import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Product.dart';
import '../../scoped_models/main.dart';

class ProductFAB extends StatefulWidget {
  final Product product;

  ProductFAB(this.product);

  @override
  _ProductFABState createState() => _ProductFABState();
}

class _ProductFABState extends State<ProductFAB> with TickerProviderStateMixin {
  AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _ctrl,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  heroTag: 'contact',
                  onPressed: () async {
                    final url = 'mailto:${widget.product.userEmail}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch.';
                    }
                  },
                  child: Icon(Icons.mail, color: Colors.blue)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _ctrl,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  tooltip:
                      widget.product.isFavorite ? 'Unfavorite' : 'Favorite',
                  heroTag: 'favorite',
                  onPressed: () {
                    model.toggleProductFavoriteStatus(widget.product.id);
                  },
                  child: Icon(
                      widget.product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red)),
            ),
          ),
          FloatingActionButton(
              onPressed: () {
                if (_ctrl.isDismissed) {
                  _ctrl.forward();
                } else {
                  _ctrl.reverse();
                }
              },
              heroTag: 'options',
              child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                        alignment: FractionalOffset.center,
                        transform:
                            Matrix4.rotationZ(_ctrl.value * .5 * math.pi),
                        child: Icon(
                            _ctrl.isDismissed ? Icons.more_vert : Icons.close));
                  }))
        ],
      );
    });
  }
}
