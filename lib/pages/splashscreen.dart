import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget child;

  SplashScreen({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: "logo",
            child: Image.asset(
              'lib/assets/logo.png',
              alignment: Alignment.topCenter,
            ),
          )
        ],
      ),
    );
  }
}
