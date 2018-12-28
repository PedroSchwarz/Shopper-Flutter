import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  GlobalKey<FormState> formKey = GlobalKey();
  String _titleCtrl;
  String _descCtrl;
  double _priceCtrl;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: <Widget>[
          ListTile(
              title: TextField(
                  onChanged: (String value) {
                    setState(() {
                      _titleCtrl = value;
                    });
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: 'Title'))),
          ListTile(
              title: TextField(
                  onChanged: (String value) {
                    setState(() {
                      _descCtrl = value;
                    });
                  },
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: 'Description'))),
          ListTile(
              title: TextField(
                  onChanged: (String value) {
                    setState(() {
                      _priceCtrl = double.parse(value);
                    });
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Price'))),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListTile(
                title: RaisedButton(
                    onPressed: () {
                      final Map<String, dynamic> product = {
                        'title': _titleCtrl,
                        'description': _descCtrl,
                        'price': _priceCtrl,
                        'image': 'assets/food.jpg'
                      };
                      widget.addProduct(product);
                      Navigator.pushReplacementNamed(context, '/products');
                    },
                    child: Text('SAVE'),
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor)),
          )
        ],
      ),
    );
  }
}
