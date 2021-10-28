// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memegen/selectmeme.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class EditMeme extends StatefulWidget {
  final String imgName;

  const EditMeme({Key? key, required this.imgName}) : super(key: key);

  @override
  _EditMemeState createState() => _EditMemeState();
}

class _EditMemeState extends State<EditMeme> {
  String topText = "Top Text";
  String bottomText = "Bottom Text";
  GlobalKey globalKey = new GlobalKey();
  double textSize = 52;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text("Add Text", style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: Stack(
              children: [
                Image.asset('assets/meme/meme/${widget.imgName}.jpg'),
                Draggable(
                  feedback: Center(child: buildStrokeText(topText, textSize)),
                  childWhenDragging: Container(),
                  child: Center(
                    child: buildStrokeText(topText, textSize),
                    // left: 180,
                  ),
                ),
                Positioned(
                  child: buildStrokeText(bottomText, textSize),
                  top: 305,
                  left: 50,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Top Text",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF7F7F7)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF7F7F7)),
                  onChanged: (value) {
                    setState(() {
                      topText = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Bottom Text",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF7F7F7)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF7F7F7)),
                  onChanged: (value) {
                    setState(() {
                      bottomText = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          textSize++;
                        });
                      },
                      child: Text(
                        " + ",
                        style: TextStyle(fontSize: 30, color: Colors.black87),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.teal[100]),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (textSize > 0) textSize--;
                        });
                      },
                      child: Text(
                        " - ",
                        style: TextStyle(fontSize: 30, color: Colors.black87),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.teal[100]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    exportMeme();
                  },
                  child: Text(
                    "Export",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                ),
                Draggable(
                  feedback: buildStrokeText("text", 20),
                  child: Text(
                    "text",
                    style: TextStyle(fontSize: 20),
                  ),
                  childWhenDragging: Container(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Stack buildStrokeText(String text, double size) {
    return Stack(
      children: [
        Text(text,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = Colors.black,
            )),
        Text(text,
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  void exportMeme() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();

      final directory = (await getApplicationDocumentsDirectory()).path;

      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
      Uint8List pngByte = byteData.buffer.asUint8List();
      File imageFile = File('$directory/meme.png');
      imageFile.writeAsBytesSync(pngByte);

      Share.shareFiles(['$directory/meme.png']);
    } catch (e) {
      print(e);
    }
  }
}
