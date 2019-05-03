import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staff_attendance/UI/drawer_control.dart';

class Summery extends StatefulWidget {
  final Widget child;
  FirebaseUser user;
  Summery({Key key, this.child, this.user}) : super(key: key);

  _SummeryState createState() => _SummeryState();
}

class _SummeryState extends State<Summery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerControl(
        selected: "Summery",
        user: widget.user,
      ),
      appBar: AppBar(
        title: Text("Summery"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Table(
              border: TableBorder.symmetric(inside: BorderSide()),
              children: [
                TableRow(children: [
                  TableCell(
                    child: Text(
                      "Date",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TableCell(
                    child: Text("User Name", textAlign: TextAlign.center),
                  ),
                  TableCell(
                    child: Text("In", textAlign: TextAlign.center),
                  ),
                  TableCell(
                    child: Text("Out", textAlign: TextAlign.center),
                  ),
                  TableCell(
                    child: Text("Hours", textAlign: TextAlign.center),
                  ),
                ])
              ],
            ),
            _handleData(),
          ],
        ),
      ),
    );
  }

  Widget _handleData() {
    return StreamBuilder(
      stream: Firestore.instance.collection('Attendance').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Summery waiting");
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            print("Attendance Data" + snapshot.data.documents.toString());

            return Table(
              children: snapshot.data.documents
                  .map<TableRow>((DocumentSnapshot document) {
                DateTime arrive =
                    DateTime.parse(document["Arrived"].toString());

                double newdifference = 0;
                if (document["Leaved"] != null) {
                  DateTime leave =
                      DateTime.parse(document["Leaved"].toString());
                  int difference = leave.difference(arrive).inMinutes;

                  newdifference = _getDifference(difference / 60);
                  print("Differance New " + newdifference.toString());
                }

                return TableRow(children: [
                  TableCell(
                    child:
                        Text(document["Arrived"].toString().substring(0, 10)),
                  ),
                  TableCell(
                    child: Text(document["UserName"].toString()),
                  ),
                  TableCell(
                    child: Text(
                        document["Arrived"].toString().substring(11, 19),
                        textAlign: TextAlign.right),
                  ),
                  TableCell(
                    child: Text(
                        document["Leaved"].toString().length < 10
                            ? "Not Yet"
                            : document["Leaved"].toString().substring(11, 19),
                        textAlign: TextAlign.right),
                  ),
                  TableCell(
                    child: Text(
                      (newdifference).toString(),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ]);
              }).toList(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return CircularProgressIndicator();
          }
          return CircularProgressIndicator();
        }
      },
    );
  }

  double _getDifference(double diffrence) {
    double newDiffrence;
    if ((diffrence % 0.5) > 0) {
      newDiffrence = 0.5 * ((diffrence / 0.5).truncate());
      newDiffrence += 0.5;
      //print("_getDifference Differance New " + newDiffrence.toString());
    } else {
      newDiffrence = diffrence;
    }
    return newDiffrence;
  }
}
