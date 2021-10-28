import 'package:flutter/material.dart';
import 'package:memegen/editmeme.dart';
import 'meme_data.dart';

class SelectMeme extends StatefulWidget {
  const SelectMeme({Key? key}) : super(key: key);

  @override
  _SelectMemeState createState() => _SelectMemeState();
}

class _SelectMemeState extends State<SelectMeme> {
  int maxItems = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Select Meme',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                for (var i = 0; i < maxItems; i++)
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditMeme(imgName: memeName[i])));
                      // print(memeName[i]);
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/meme/meme/${memeName[i]}.jpg',
                        fit: BoxFit.cover,
                      ),
                      width: ((MediaQuery.of(context).size.width - 4) / 3),
                      height: ((MediaQuery.of(context).size.width - 4) / 3),
                    ),
                  )
              ],
            ),
            maxItems < memeName.length
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        if (maxItems + 20 < memeName.length) {
                          maxItems += 20;
                        } else {
                          maxItems = memeName.length;
                        }
                      });
                    },
                    child: Text('Load more'),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
