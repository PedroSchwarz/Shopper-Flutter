import 'package:flutter/material.dart';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/form_inputs/location.dart';
import '../widgets/form_inputs/image.dart';

import '../models/Product.dart';
import '../models/LocationData.dart';
import '../scoped_models/main.dart';

class ProductEditPage extends StatefulWidget {
  final String id;

  ProductEditPage(this.id);

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _product = {
    'title': null,
    'description': null,
    'price': null,
    'image': null
  };

  Widget _buildTitleTextField(String title) {
    return ListTile(
        title: TextFormField(
            initialValue: title,
            onSaved: (String value) => _product['title'] = value,
            validator: (String value) {
              return value.trim().isEmpty ? 'The title cannot be empty' : null;
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: 'Title')));
  }

  Widget _buildDescTextField(String description) {
    return ListTile(
        title: TextFormField(
            initialValue: description,
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

  Widget _buildPriceTextField(double price) {
    return ListTile(
        title: TextFormField(
            initialValue: price.toString(),
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

  Widget _buildSubmitButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              onPressed: () => _submitForm(context, model.updateProduct),
              child: Text('UPDATE'),
              textColor: Colors.white);
    });
  }

  void _setImage(File image) {
    _product['image'] = image;
  }

  void _submitForm(BuildContext context, Function updateProduct) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      updateProduct(_product['title'], _product['description'],
              _product['price'], _product['image'], widget.id)
          .then((bool success) {
        if (success) {
          Navigator.pop(context);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Something Went Wrong.'),
                    content: Text('Please try again later.'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'))
                    ]);
              });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.fetchSingleProduct(widget.id);
      return Scaffold(
          appBar: AppBar(title: Text('Edit ${product.title}')),
          body: Form(
              key: _formKey,
              child: ListView(children: <Widget>[
                _buildTitleTextField(product.title),
                _buildDescTextField(product.description),
                _buildPriceTextField(product.price),
//          LocationInput(_setLocation, product),
                ImageInput(_setImage, product: product),
                ListTile(title: _buildSubmitButton(context)),
              ])));
    });
  }
}
