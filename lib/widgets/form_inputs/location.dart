import 'package:flutter/material.dart';
import 'dart:convert';

//import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;

import '../../models/Product.dart';
import '../../models/LocationData.dart';

import '../../helpers/global_config.dart';

class LocationInput extends StatefulWidget {
//  final Function setLocation;
//  final Product product;

//  LocationInput(this.setLocation, this.product);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressFocus = FocusNode();
  Uri _staticMapUri;
  LocationData _locationData;
  final TextEditingController _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
//    getStaticMap();
//    if (widget.product != null) {
//      getStaticMap(widget.product.location)
//    }
    _addressFocus.addListener(_updateLocation);
  }

  @override
  void dispose() {
    super.dispose();
    _addressFocus.removeListener(_updateLocation);
  }

  void getStaticMap(String address) async {
//    if (address.trim().isEmpty) {
//      setState(() {
//        _staticMapUri = null;
//        widget.setLocation(null);
//        return;
//      });
//    }
//    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
//        {'address': address, 'key': apiKey});
//    final http.Response res = await http.get(uri);
//    final resData = json.decode(res.body);
//    final formattedAddress = resData['results'][0]['formatted_address'];
//    final coords = resData['results'][0]['geometry']['location'];
//    _locationData = LocationData(
//        latitude: coords['lat'],
//        longitude: coords['lng'],
//        address: formattedAddress);
//    final StaticMapProvider staticMapProvider =
//    StaticMapProvider(apiKey);
//    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
//        [Marker('position', 'Position', _locationData.latitude, _locationData.longitude)],
//        center: Location(_locationData.latitude, _locationData.longitude)),
//        height: 300,
//        width: 500,
//        maptype: StaticMapViewType.roadmap);
//    widget.setLocation(_locationData);
//    setState(() {
//      _addressCtrl.text = _locationData.address;
//      _staticMapUri = staticMapUri;
//    });
  }

  void _updateLocation() {
    if (!_addressFocus.hasFocus) {
      getStaticMap(_addressCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
          title: TextFormField(
              focusNode: _addressFocus,
              controller: _addressCtrl,
              onSaved: (String value) {},
              validator: (String value) {
                if (_locationData == null || value.trim().isEmpty) {
                  return 'The location cannot be empty';
                }
              },
              decoration: InputDecoration(labelText: 'Location'))),
//      Image.network(_staticMapUri.toString())
    ]);
  }
}
