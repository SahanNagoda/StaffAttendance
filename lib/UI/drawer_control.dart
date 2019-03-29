import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/home.dart';

class DrawerControl extends StatelessWidget {
  String selected;
  final FirebaseUser user;
  DrawerControl({String selected, this.user}) {
    this.selected = selected;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            selected: selected == "Home",
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home(user: user)));
            },
          ),
          ListTile(
            selected: selected == "Add User",
            leading: Icon(Icons.person_add),
            title: Text("Add User"),
            onTap: () {
              
            },
          ),
          ListTile(
            selected: selected == "Summery",
            leading: Icon(Icons.storage),
            title: Text("Summery"),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }
}
