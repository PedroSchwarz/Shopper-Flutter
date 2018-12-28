import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _title;
  String _desc;
  double _price;

  Widget _buildTitleTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) {
              setState(() {
                _title = value;
              });
            },
            validator: (String value) {
              return value.trim().isEmpty ? 'The title cannot be empty' : null;
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: 'Title')));
  }

  Widget _buildDescTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) {
              setState(() {
                _desc = value;
              });
            },
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
            onSaved: (String value) {
              setState(() {
                _price = double.parse(value);
              });
            },
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
      final Map<String, dynamic> product = {
        'title': _title,
        'description': _desc,
        'price': _price,
        'image': 'assets/food.jpg'
      };
      widget.addProduct(product);
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
