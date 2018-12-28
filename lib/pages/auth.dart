import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _emailCtrl;
  TextEditingController _passCtrl;

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
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password')));
  }

  void _submitForm() {
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          child: Center(
            child: SingleChildScrollView(
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
        ));
  }
}
