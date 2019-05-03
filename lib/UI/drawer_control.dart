import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/home.dart';
import '../pages/summery.dart';

class DrawerControl extends StatefulWidget {
  String selected;
  final FirebaseUser user;
  DrawerControl({String selected, this.user}) {
    this.selected = selected;
  }

  @override
  _DrawerControlState createState() => _DrawerControlState();
}

class _DrawerControlState extends State<DrawerControl> {
  String userName ="Welcome";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(userName),
          ),
          _handleDrawer(),
        ],
      ),
    );
  }

  Widget _home() {
    return ListTile(
      selected: widget.selected == "Home",
      leading: Icon(Icons.home),
      title: Text("Home"),
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home(user: widget.user)));
      },
    );
  }

  Widget _addUser() {
    return ListTile(
      selected: widget.selected == "Add User",
      leading: Icon(Icons.person_add),
      title: Text("Add User"),
      onTap: () {},
    );
  }

  Widget _summery() {
    return ListTile(
      selected: widget.selected == "Summery",
      leading: Icon(Icons.storage),
      title: Text("Summery"),
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Summery(user: widget.user)));
      },
    );
  }

  Widget _handleDrawer() {
    return new StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(widget.user.uid)
            .get()
            .asStream(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Drawer waiting");
            return _home();
          } else {
            if (snapshot.hasData) {
              print(snapshot.data);
              
              if (snapshot.data["Type"] == "Admin") {
                return Column(
                  children: <Widget>[_home(), _summery(), _addUser()],
                );
              } else if (snapshot.data["Type"] == "User1") {
                return Column(
                  children: <Widget>[_home(), _summery()],
                );
              } else {
                return _home();
              }
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return _home();
            }
            return _home();
          }
        });
  }
}
