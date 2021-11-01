// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memegen/selectCategory.dart';
import 'goods_data.dart';

class payPage extends StatefulWidget {
  final double currencyRate;
  final String dropdownValue;
  final List<int> selectedItem;
  final Function() notifyParent_;
  final Function(int) callback;
  const payPage({
    Key? key,
    required this.currencyRate,
    required this.dropdownValue,
    required this.selectedItem,
    required this.notifyParent_,
    required this.callback,
  }) : super(key: key);

  @override
  _payPageState createState() => _payPageState();
}

class _payPageState extends State<payPage> {
  double total = 0;
  @override
  Widget build(BuildContext context) {
    total = totalCalculate();
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            currentItem = 0;

            for (int i = 0; i < itemNum; i++) {
              currentItem += selectedItem[i];
            }
            widget.callback(currentItem);
            widget.notifyParent_;
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.pink[200],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              for (int i = 0; i < itemNum; i++)
                if (widget.selectedItem[i] != 0)
                  goodsSelected(
                    current: i,
                    currencyRate: widget.currencyRate,
                    dropdownValue: widget.dropdownValue,
                    selectedItem: widget.selectedItem,
                    notifyParent: update,
                  ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Total ${total} ${widget.dropdownValue}",
                style: TextStyle(fontFamily: 'Prompt', fontSize: 30),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  "Pay",
                  style: TextStyle(
                      fontFamily: 'Prompt', fontSize: 20, color: Colors.black),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.pink[100])),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )
        ],
      ),
    );
  }

  double totalCalculate() {
    double sum = 0;
    for (int i = 0; i < itemNum; i++) {
      sum += goodsPrice[i] * widget.selectedItem[i];
    }
    sum = sum * currencyRate;
    sum = double.parse(sum.toStringAsFixed(2));
    return sum;
  }

  void update(value) {
    setState(() {
      total = value;
    });
  }
}

class goodsSelected extends StatefulWidget {
  const goodsSelected(
      {Key? key,
      required this.current,
      required this.currencyRate,
      required this.dropdownValue,
      required this.selectedItem,
      required this.notifyParent})
      : super(key: key);
  final int current;
  final double currencyRate;
  final String dropdownValue;
  final List<int> selectedItem;
  final Function(double) notifyParent;
  @override
  _goodsSelectedState createState() => _goodsSelectedState();
}

class _goodsSelectedState extends State<goodsSelected> {
  double totalCalculate() {
    double sum = 0;
    for (int i = 0; i < itemNum; i++) {
      sum += goodsPrice[i] * widget.selectedItem[i];
    }
    sum = sum * currencyRate;
    sum = double.parse(sum.toStringAsFixed(2));
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 10,
            ),
            Text(
              "${goodsName[widget.current]}",
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  ("${(goodsPrice[widget.current] * widget.currencyRate * widget.selectedItem[widget.current]).toStringAsFixed(2)} ${widget.dropdownValue}"),
                  style: TextStyle(fontFamily: 'Prompt', fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(
                          () {
                            if (widget.selectedItem[widget.current] > 0) {
                              widget.selectedItem[widget.current]--;
                              widget.notifyParent(totalCalculate());
                            }
                          },
                        );
                      },
                      icon: Icon(Icons.remove),
                      color: Colors.red,
                    ),
                    Text(
                      "${widget.selectedItem[widget.current]}",
                      style: TextStyle(fontFamily: 'Prompt', fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.selectedItem[widget.current]++;
                          widget.notifyParent(totalCalculate());
                        });
                      },
                      icon: Icon(Icons.add),
                      color: Colors.green,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(10)),
        height: 120,
        width: 350,
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }
}
