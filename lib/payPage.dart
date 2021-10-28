// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class payPage extends StatefulWidget {
  const payPage({Key? key}) : super(key: key);

  @override
  _payPageState createState() => _payPageState();
}

class _payPageState extends State<payPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.pink[200],
    ));
  }
}
