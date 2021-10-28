// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Selectcurrency extends StatefulWidget {
  const Selectcurrency({Key? key}) : super(key: key);

  @override
  _SelectcurrencyState createState() => _SelectcurrencyState();
}

class _SelectcurrencyState extends State<Selectcurrency> {
  String dropdownValue = 'One';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
