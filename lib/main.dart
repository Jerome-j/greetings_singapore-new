import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:screenshot/screenshot.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class OtherInformation {
  double x_coor = 0;
  double y_coor = 0;
  Color fontColor;

  OtherInformation({this.x_coor, this.y_coor, this.fontColor});
}

class _HomeState extends State<Home> {
  int counter = 0;
  String greeting_type = "早安";

  double _x = 0, _y = 0;

  Map choices = {
    '早安': OtherInformation(x_coor: 0, y_coor: 0, fontColor: Colors.blue),
    '愿你每天都健康开心!':
        OtherInformation(x_coor: 20, y_coor: 20, fontColor: Colors.yellow),
    '🍅': OtherInformation(x_coor: 40, y_coor: 40, fontColor: Colors.green),
  };

  List images = [
    'https://www.dhresource.com/0x0/f2/albu/g4/M00/12/49/rBVaEFmVotuAXou9AAL3rP5jSuc531.jpg',
    'https://cdn.shopify.com/s/files/1/0151/0741/products/8308d18a3554e8371468333d04fb1e45_1024x1024.jpeg?v=1578638832',
    'https://farm3.staticflickr.com/2372/2399997081_53a9647304_o.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT1eqwAt9m_uXAoQziN8un39wSycemRK5HYOQ&usqp=CAU'
  ];

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  screenshot() {
    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((File image) async {
      Image img = Image.file(image);
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64.encode(imageBytes);

      await FlutterShareMe().shareToWhatsApp(
          base64Image: 'data:image/jpeg;base64,' + base64Image, msg: "Text");
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Good morning 🇸🇬"),
          actions: <Widget>[
            RaisedButton.icon(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              label: Text("WhatsApp"),
              onPressed: () {
                screenshot();
              },
              color: Colors.red,
            )
          ],
          backgroundColor: Colors.red,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: <Widget>[
                    Container(
                        child: Image.network(images[counter]),
                        // TODO: Temporary fit the height of image to width, need to implement more logic to check if length and heights are equal etc
                        height: MediaQuery
                            .of(context)
                            .size
                            .width),
                    // TODO: Random font size and type -> safe area
                    // TODO: Random Location

                    Container(
                      // TODO: Temporary fit the height of image to width, need to implement more logic to check if length and heights are equal etc
                      height: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Stack(
                        // TODO: Looping a map
                        children: choices.keys.map((emoji) {
                          OtherInformation otherInformation = choices[emoji];

                          GreetingTextFormatted greetingTextFormatted =
                          new GreetingTextFormatted(
                            greetingText: emoji,
                            fontColor: otherInformation.fontColor,
                          );

                          return Positioned(
                            left: otherInformation.x_coor,
                            top: otherInformation.y_coor,
                            child: Draggable(
                              data: greetingTextFormatted,
                              child: greetingTextFormatted,
                              feedback: greetingTextFormatted,
                              onDragEnd: (dragDetails) {
                                double appBarHeight =
                                    AppBar().preferredSize.height;
                                double statusBarHeight =
                                    MediaQuery
                                        .of(context)
                                        .padding
                                        .top;

                                otherInformation.x_coor = dragDetails.offset.dx;
                                // if applicable, don't forget offsets like app/status bar
                                otherInformation.y_coor =
                                    dragDetails.offset.dy -
                                        appBarHeight -
                                        statusBarHeight;

                                setState(() {
//                                  choices[emoji] = otherInformation;

                                  choices.update(emoji, (oldValue) {
                                    print(oldValue.x_coor.toString() +
                                        " ___ " +
                                        otherInformation.x_coor.toString());
                                    return otherInformation;
                                  });

                                  print(choices[emoji].x_coor);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
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
                  // TODO: Different text type for app -> 祝你有一个美丽的早晨 etc
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
              ),
            ],
          ),
        ));
  }
}

class GreetingTextFormatted extends StatelessWidget {
  GreetingTextFormatted({Key key, this.greetingText, this.fontColor})
      : super(key: key);

  final Color fontColor;
  final String greetingText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(greetingText,
              style: TextStyle(
                  color: fontColor, fontSize: 60, fontFamily: 'Arial'))),
    );
  }
}
