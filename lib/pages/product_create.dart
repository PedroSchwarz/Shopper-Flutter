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

  Widget _buildTitleTextField() {
    return ListTile(
        title: TextField(
            onChanged: (String value) {
              setState(() {
                _titleCtrl = value;
              });
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: 'Title')));
  }

  Widget _buildDescTextField() {
    return ListTile(
        title: TextField(
            onChanged: (String value) {
              setState(() {
                _descCtrl = value;
              });
            },
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: 'Description')));
  }

  Widget _buildPriceTextField() {
    return ListTile(
        title: TextField(
            onChanged: (String value) {
              setState(() {
                _priceCtrl = double.parse(value);
              });
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Price')));
  }

  void _submitForm() {
    final Map<String, dynamic> product = {
      'title': _titleCtrl,
      'description': _descCtrl,
      'price': _priceCtrl,
      'image': 'assets/food.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
