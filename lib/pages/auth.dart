import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> user = {'email': null, 'password': null};

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        image: AssetImage('assets/japan.jpg'),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(.3), BlendMode.dstATop));
  }

  Widget _buildEmailTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => user['email'] = value,
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'E-mail cannot be empty';
              } else if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'Invalid e-mail';
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                labelText: 'E-mail')));
  }

  Widget _buildPassTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => user['password'] = value,
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'The password cannot be empty';
              } else if (value.trim().length < 6) {
                return 'The password must contain at least 6 characters';
              }
            },
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password')));
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pushReplacementNamed(context, '/products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  _buildEmailTextField(),
                  _buildPassTextField(),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ListTile(
                          title: RaisedButton(
                              onPressed: _submitForm,
                              child: Text('LOGIN'),
                              textColor: Colors.white)))
                ]),
              ),
            ),
          ),
        ));
  }
}
