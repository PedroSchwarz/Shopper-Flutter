import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _emailCtrl;
  TextEditingController _passCtrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/japan.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(.3), BlendMode.dstATop))),
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                ListTile(
                    title: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            labelText: 'E-mail'))),
                ListTile(
                    title: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password'))),
                Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ListTile(
                        title: RaisedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/products');
                      },
                      child: Text('LOGIN'),
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                    )))
              ]),
            ),
          ),
        ));
  }
}
