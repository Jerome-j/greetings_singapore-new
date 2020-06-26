import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;
  String greeting_type = "早安";

  List images = [
    'https://www.dhresource.com/0x0/f2/albu/g4/M00/12/49/rBVaEFmVotuAXou9AAL3rP5jSuc531.jpg',
    'https://cdn.shopify.com/s/files/1/0151/0741/products/8308d18a3554e8371468333d04fb1e45_1024x1024.jpeg?v=1578638832',
    'https://farm3.staticflickr.com/2372/2399997081_53a9647304_o.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT1eqwAt9m_uXAoQziN8un39wSycemRK5HYOQ&usqp=CAU'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Good morning Singapore"),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: <Widget>[
            new Stack(
              children: <Widget>[
                Image.network(images[counter]),
                Center(
                    child: Text(greeting_type,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40))),
              ],
            ),
            Text("Credits: Flickr"),
            RaisedButton(
              onPressed: () {
                setState(() {
                  if (counter > counter.bitLength)
                    counter = 0;
                  else
                    counter++;
                });
              },
              child: Text("Change image"),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    onPressed: () {
                      setState(() {
                        greeting_type = "早安";
                      });
                    },
                    child: Text("早")),
                RaisedButton(
                    onPressed: () {
                      setState(() {
                        greeting_type = "午安";
                      });
                    },
                    child: Text("午")),
                RaisedButton(
                    onPressed: () {
                      setState(() {
                        greeting_type = "晚安";
                      });
                    },
                    child: Text("晚")),
              ],
            )
          ],
        ));
  }
}
