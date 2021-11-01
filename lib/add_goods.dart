// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memegen/goods_data.dart';
import 'package:memegen/selectCategory.dart';

class AddGoods extends StatefulWidget {
  const AddGoods({Key? key, required this.notifyParents}) : super(key: key);
  final Function(int) notifyParents;
  @override
  _AddGoodsState createState() => _AddGoodsState();
}

class _AddGoodsState extends State<AddGoods> {
  String name = '';
  double price = 0;
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
          title: Center(child: Text("Add goods"))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration:
                  InputDecoration(labelText: "Name", hintText: "Name of goods"),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Price", hintText: "Price of goods"),
              onChanged: (value) {
                setState(() {
                  price = double.parse(value);
                });
              },
            ),
          ),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.lightGreen[400])),
              onPressed: () {
                if (name != '' && price != 0) {
                  goodsName.add(name);
                  goodsPrice.add(price);
                }
                itemNum = goodsName.length;
                widget.notifyParents(itemNum);
                Navigator.pop(context);
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add this goods",
                style: TextStyle(fontSize: 20, fontFamily: 'Prompt'),
              )),
        ],
      ),
    );
  }
}
