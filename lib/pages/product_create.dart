import 'package:flutter/material.dart';

import '../models/Product.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _product = {
    'title': null,
    'description': null,
    'price': null,
    'image': null
  };

  Widget _buildTitleTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _product['title'] = value,
            validator: (String value) {
              return value.trim().isEmpty ? 'The title cannot be empty' : null;
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: 'Title')));
  }

  Widget _buildDescTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _product['description'] = value,
            validator: (String value) {
              return value.trim().isEmpty
                  ? 'The description cannot be empty'
                  : null;
            },
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: 'Description')));
  }

  Widget _buildPriceTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _product['price'] = double.parse(value),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'The price cannot be empty';
              } else if (double.parse(value) < 0) {
                return 'The price has to be equal or greater than 0';
              }
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Price')));
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _product['image'] = 'assets/food.jpg';
      widget.addProduct(Product(
          title: _product['title'],
          description: _product['description'],
          price: _product['price'],
          image: _product['image']));
      Navigator.pushReplacementNamed(context, '/products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTitleTextField(),
          _buildDescTextField(),
          _buildPriceTextField(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListTile(
                title: RaisedButton(
                    onPressed: _submitForm,
                    child: Text('SAVE'),
                    textColor: Colors.white)),
          )
        ],
      ),
    );
  }
}
