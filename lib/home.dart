import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        leading: Text(
          'Leading',
          style: TextStyle(
            fontSize: 24,
            color: Colors.pink,
          ),
        ),
        title: Center(child: Text('title')),
        actions: [
          Text('Action'),
          Text('Action2'),
          Text('Action3'),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
                child: Image(
              image: AssetImage('./assets/ellipse.png'),
            )),
          ),

          Center(
            child: Container(
              // color: Colors.pink,
              child: Image(
                image: AssetImage('./assets/shiba.png'),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                "data",
                style: TextStyle(fontSize: 30),
              ),
            ),
          )

          // Container(
          //   color: Colors.red,
          // ),
          // Container(
          //   color: Colors.green,
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
      ),
    );
  }
}
