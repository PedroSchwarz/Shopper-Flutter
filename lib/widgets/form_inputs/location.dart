import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _addressFocus.addListener(_updateLocation);
  }

  @override
  void dispose() {
    super.dispose();
    _addressFocus.removeListener(_updateLocation);
  }

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
          title: TextFormField(
              focusNode: _addressFocus,
              onSaved: (String value) {},
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'The location cannot be empty';
                }
              },
              decoration: InputDecoration(labelText: 'Location')))
    ]);
  }
}
