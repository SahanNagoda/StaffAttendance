import 'package:flutter/material.dart';



class Login extends StatefulWidget {
  final Widget child;

  Login({Key key, this.child}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email,_password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Builder(
        builder: (BuildContext context) => Container(
              margin: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/logo.png',
                      width: 250.0,
                      height: 250.0,
                      alignment: Alignment.topCenter,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Email"),
                      onSaved: (value) => _email =value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ("Enter Email");
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      onSaved: (value) =>_password = value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ("Enter Valid Password");
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: RaisedButton(
                        child: Text("Login"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }

  void _logIn(){

  }

}
