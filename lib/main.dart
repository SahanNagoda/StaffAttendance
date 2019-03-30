import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import './Pages/login.dart';
import './Pages/home.dart';
import './Pages/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("SplashScreen");
            return SplashScreen();
          } else {
            
            if (snapshot.hasData) {
              print(snapshot.data);
              
              return new Home(
                user: snapshot.data
              );
              
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return SplashScreen();
            }
            return new Login();
          }
        });
  }
}
