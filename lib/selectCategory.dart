// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:memegen/payPage.dart';
import 'package:memegen/selectCurrency.dart';
import 'package:memegen/selectmeme.dart';
import 'package:http/http.dart' as http;
import 'goods_data.dart';

class SelectCategory extends StatefulWidget {
  final String userName;
  const SelectCategory({Key? key, required this.userName}) : super(key: key);
  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  int currentIndex = 0;

  String dropdownValue = 'THB';
  double currencyRate = 1;
  double itemPrice1 = 100.00;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi ${widget.userName}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => payPage()));
            },
            child: Icon(Icons.shopping_cart, color: Colors.white),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.pink[200],
      ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: [
            ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    for (int i = 0; i < itemNum; i++)
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            Text(
                              "${goodsName[i]}",
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
                                  height: 16,
                                ),
                                Text(
                                  ("${goodsPrice[i] * currencyRate} ${dropdownValue}"),
                                  style: TextStyle(
                                      fontFamily: 'Prompt', fontSize: 20),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Add to cart",
                                    style: TextStyle(
                                        fontFamily: 'Prompt',
                                        color: Colors.deepOrange),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.amber[100])),
                                )
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        height: 120,
                        width: 350,
                        padding: const EdgeInsets.all(10.0),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
            Container(
                child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30,
              elevation: 16,
              style: const TextStyle(
                  color: Colors.deepPurple, fontSize: 20, fontFamily: 'Prompt'),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) async {
                setState(
                  () {
                    dropdownValue = newValue!;
                  },
                );
                if (dropdownValue == 'USD') {
                  var url = Uri.parse(
                      "https://free.currconv.com/api/v7/convert?q=THB_USD&compact=ultra&apiKey=ec43a656e79c9e710cf9");
                  var response = await http.get(url);
                  String res = response.body;
                  currencyRate = jsonToCurrency(res);
                } else if (dropdownValue == 'THB') {
                  currencyRate = 1;
                } else if (dropdownValue == 'EUR') {
                  var url = Uri.parse(
                      "https://free.currconv.com/api/v7/convert?q=THB_EUR&compact=ultra&apiKey=ec43a656e79c9e710cf9");
                  var response = await http.get(url);
                  String res = response.body;
                  currencyRate = jsonToCurrency(res);
                } else if (dropdownValue == 'CNY') {
                  var url = Uri.parse(
                      "https://free.currconv.com/api/v7/convert?q=THB_CNY&compact=ultra&apiKey=ec43a656e79c9e710cf9");
                  var response = await http.get(url);
                  String res = response.body;
                  currencyRate = jsonToCurrency(res);
                }
                ;
              },
              items: <String>['THB', 'USD', 'EUR', 'CNY']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            pageController.jumpToPage(currentIndex);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

double jsonToCurrency(String res) {
  int first = 0, last = 0;
  for (int i = 0; i < res.length; i++) {
    if (res[i] == ':') first = (i + 1);
    if (res[i] == '}') last = i;
  }
  res = res.substring(first, last);
  double currency = double.parse(res);
  currency = double.parse(currency.toStringAsFixed(3));
  return currency;
}
