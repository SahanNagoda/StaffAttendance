import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../UI/drawer_control.dart';

class Home extends StatelessWidget {
  final FirebaseUser user;

  Home({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerControl(
        selected: "Home",
        user: user,
      ),
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out"),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Text("Welcome Home " + user.toString()),
    );
  }
}
