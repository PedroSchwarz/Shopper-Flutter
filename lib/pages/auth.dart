import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/Auth.dart';

import '../scoped_models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _user = {'email': null, 'password': null};
  final TextEditingController _passCtrl = TextEditingController();

  AuthMode _authMode = AuthMode.Login;

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
            onSaved: (String value) => _user['email'] = value,
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
            controller: _passCtrl,
            onSaved: (String value) => _user['password'] = value,
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

  Widget _buildPassConfirmTextField() {
    return ListTile(
        title: TextFormField(
            validator: (String value) {
              if (_passCtrl.text != value) {
                return 'Passwords must match';
              }
            },
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                labelText: 'Confirm password')));
  }

  void _submitForm(Function authenticate) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> authInfo =
          await authenticate(_user['email'], _user['password'], _authMode);
      if (authInfo['success']) {
//        Navigator.pushReplacementNamed(context, '/');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text('An Error Occured.'),
                  content: Text(authInfo['message']),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop())
                  ]);
            });
      }
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
                          _authMode == AuthMode.Signup
                              ? _buildPassConfirmTextField()
                              : Container(),
                          ListTile(
                              title: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      _authMode = _authMode == AuthMode.Login
                                          ? AuthMode.Signup
                                          : AuthMode.Login;
                                    });
                                  },
                                  color: Colors.white,
                                  textColor: Theme.of(context).accentColor,
                                  child: Text(
                                      'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'))),
                          ListTile(title: ScopedModelDescendant<MainModel>(
                              builder: (BuildContext context, Widget child,
                                  MainModel model) {
                            return model.isLoading
                                ? Center(child: CircularProgressIndicator())
                                : RaisedButton(
                                    onPressed: () =>
                                        _submitForm(model.authenticate),
                                    child: Text(_authMode == AuthMode.Login
                                        ? 'LOGIN'
                                        : 'SIGN UP'),
                                    textColor: Colors.white);
                          }))
                        ]))))));
  }
}
