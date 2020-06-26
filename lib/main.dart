import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Good morning Singapore"),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: <Widget>[
            Text("1"),
            Text("2"),
            Text("3"),
            Text("4"),
            Text("5"),
          ],
        ));
  }
}
