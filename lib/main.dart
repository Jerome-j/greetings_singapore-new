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
  double fontSize;
  String greetingText;

  OtherInformation(
      {this.x_coor,
      this.y_coor,
      this.fontColor,
      this.fontSize,
      this.greetingText});
}

class _HomeState extends State<Home> {
  int counter = 0;
  String greeting_type = "早安";

  final int _fields = 10;

  List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(_fields, (i) => TextEditingController());
  }

  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  Map choices = {
    0: OtherInformation(
        x_coor: 0,
        y_coor: 0,
        fontColor: Colors.blue,
        fontSize: 30,
        greetingText: "早安 1"),
    1: OtherInformation(
        x_coor: 20,
        y_coor: 20,
        fontColor: Colors.yellow,
        fontSize: 40,
        greetingText: '愿你每天都健康开心!1'),
    2: OtherInformation(
        x_coor: 40,
        y_coor: 40,
        fontColor: Colors.green,
        fontSize: 60,
        greetingText: '🍅1'),
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
    TextEditingController myController = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
      super.dispose();
    }

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
                        height: MediaQuery.of(context).size.width),
                    // TODO: Random font size and type -> safe area
                    // TODO: Random Location

                    Container(
                      // TODO: Temporary fit the height of image to width, need to implement more logic to check if length and heights are equal etc
                      height: MediaQuery.of(context).size.width,
                      child: Stack(
                        // TODO: Looping a map
                        children: choices.keys.map((emoji) {
                          OtherInformation otherInformation = choices[emoji];

                          controllers[emoji].text =
                              otherInformation.greetingText;

                          controllers[emoji].selection =
                              TextSelection.collapsed(
                                  offset: otherInformation.greetingText.length);

                          GreetingTextFormatted greetingTextFormatted =
                              new GreetingTextFormatted(
                            greetingText: otherInformation.greetingText,
                            fontColor: otherInformation.fontColor,
                            fontSize: otherInformation.fontSize,
                          );

                          return Positioned(
                            left: otherInformation.x_coor,
                            top: otherInformation.y_coor,
                            child: GestureDetector(
                              onTap: () {
                                print("tapped" + emoji.toString());
                                // set up the AlertDialog
                                AlertDialog alert = AlertDialog(
                                    // https://stackoverflow.com/questions/60163123/flutter-detect-tap-on-the-screen-that-is-filled-with-other-widgets
                                    title: Row(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            iconSize: 10,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Align(
                                          child: Text('更改文字和设计'),
                                          alignment: Alignment.topLeft,
                                        ),
                                      ],
                                    ),
                                    content: Column(
                                      children: <Widget>[
                                        TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: controllers[emoji],
//                                            initialValue:
//                                                otherInformation.greetingText,
                                            style: TextStyle(
                                                color:
                                                otherInformation.fontColor,
                                                fontSize:
                                                otherInformation.fontSize)),
                                        Row(
                                          children: <Widget>[
                                            RaisedButton(
                                              child: Text("删除"),
                                              color: Colors.red,
                                              onPressed: () {
                                                setState(() {
                                                  choices.remove(emoji);
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            RaisedButton(
                                              child: Text("更改"),
                                              color: Colors.green,
                                              onPressed: () {
                                                setState(() {
                                                  if (controllers[emoji]
                                                      .text
                                                      .toString()
                                                      .isNotEmpty) {
                                                    OtherInformation a =
                                                    choices[emoji];
                                                    a.greetingText =
                                                        controllers[emoji]
                                                            .text
                                                            .toString();
                                                    choices[emoji] = a;
                                                  } else {
                                                    setState(() {
                                                      choices.remove(emoji);
                                                    });
                                                  }
                                                });
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ));

                                // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
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

                                  otherInformation.x_coor =
                                      dragDetails.offset.dx;
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
                          OtherInformation a = choices[0];
                          a.greetingText = "早安";
                          choices[0] = a;
                        });
                      },
                      child: Text("早")),
                  RaisedButton(
                      onPressed: () {
                        setState(() {
                          OtherInformation a = choices[0];
                          a.greetingText = "午安";
                          choices[0] = a;
                        });
                      },
                      child: Text("午")),
                  RaisedButton(
                      onPressed: () {
                        setState(() {
                          OtherInformation a = choices[0];
                          a.greetingText = "晚安";
                          choices[0] = a;
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
  GreetingTextFormatted(
      {Key key, this.greetingText, this.fontColor, this.fontSize})
      : super(key: key);

  final Color fontColor;
  final String greetingText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(greetingText,
              style: TextStyle(
                  color: fontColor, fontSize: fontSize, fontFamily: 'Arial'))),
    );
  }
}
