import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  ProductListPage(this.products);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
                backgroundImage: AssetImage(widget.products[index]['image'])),
            title: Text(widget.products[index]['title']),
            trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () =>
                    Navigator.pushNamed(context, '/product/edit/$index')),
          );
        });
  }
}
