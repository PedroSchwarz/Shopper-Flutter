import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
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
      )
    ]);
  }
}
