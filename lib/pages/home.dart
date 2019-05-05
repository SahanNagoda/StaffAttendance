import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../UI/drawer_control.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;

  Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String document;
  DocumentSnapshot userDetail;
  bool isArrived = false;
  bool isLeaved = false;
  @override
  void initState() {
    
    _getUserDetail();
    _checkAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerControl(
                selected: "Home",
                user: widget.user,
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
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(userDetail !=null ? "Welcome "+userDetail.data["Name"]:"Loading...",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center,),
              SizedBox(
                height: 200.0,
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text(
                    "Arrive",
                    textScaleFactor: 5.0,
                  ),
                  onPressed: isArrived ? null : _handelArrive,
                ),
              ),
              SizedBox(
                height: 200.0,
                child: RaisedButton(
                  child: Text(
                    "Leave",
                    textScaleFactor: 5.0,
                  ),
                  onPressed: isLeaved ? null : _handelLeave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _handelArrive() async {
    DateTime now = DateTime.now();

    print("Arreived");
    await Firestore.instance.collection('Attendance').document().setData({
      'userId': widget.user.uid,
      'Arrived': now,
      'UserName': userDetail.data["Name"]
    }).whenComplete(() {
      print("Arreived Complete");
    }).catchError((e) => print("Arreived Error"));
    print("Arreived Finish");
  }

  Future _handelLeave() async {
    DateTime now = DateTime.now();

    print("Leaved");
    await Firestore.instance
        .collection('Attendance')
        .document(document)
        .updateData({'userId': widget.user.uid, 'Leaved': now}).whenComplete(
            () {
      print("Leaved Complete");
    }).catchError((e) => print("Arreived Error"));
    print("Leaved Finish");
  }

  Future _getUserDetail() async {
    
    print("Getting USerDetails");
    await Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      print("SnapShot " + ds.data.toString());
      setState(() {
        userDetail = ds;
      });
    });
    print("Finish USerDetails");
  }

  

  Future _checkAttendance() async {
    DateTime now = DateTime.now();

    print("check Attendance");
    Query query = Firestore.instance
        .collection('Attendance')
        .where("userId", isEqualTo: widget.user.uid)
        .where("Arrived",
            isGreaterThan: now.subtract(new Duration(
                hours: now.hour, minutes: now.minute, seconds: now.second)));

    query.snapshots().listen((data) {
      data.documents.forEach((doc) {
        print(now
                .subtract(new Duration(
                    hours: now.hour, minutes: now.minute, seconds: now.second))
                .toString() +
            " check " +
            doc["userId"].toString() +
            " " +
            doc.documentID);
        setState(() {
          document = doc.documentID;
          isArrived = true;
          isLeaved = doc["Leaved"] != null;
        });
      });
    });
    print("check Attendance Finish ");
  }
}
