import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../models/Product.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;

  ImageInput(this.setImage, {this.product});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 170.0,
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text('Pick an Image',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                ),
                FlatButton(
                    child: Text('Use Camera'),
                    onPressed: () => _getImage(context, ImageSource.camera),
                    textColor: accentColor),
                FlatButton(
                    child: Text('Use Galley'),
                    onPressed: () => _getImage(context, ImageSource.gallery),
                    textColor: accentColor)
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    Widget previewImage = Text('Please select an image.');
    if (_imageFile != null) {
      previewImage = Image.file(_imageFile,
          fit: BoxFit.cover,
          height: 300.0,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center);
    } else if (widget.product != null) {
      previewImage = Image.network(widget.product.imageUrl,
          fit: BoxFit.cover,
          height: 300.0,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center);
    }
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListTile(
          title: OutlineButton(
              onPressed: () => _openImagePicker(context),
              borderSide: BorderSide(color: accentColor, width: 1.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.camera, color: accentColor),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('ADD IMAGE',
                          style: TextStyle(color: accentColor)),
                    )
                  ])),
        ),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: previewImage)
    ]);
  }
}
