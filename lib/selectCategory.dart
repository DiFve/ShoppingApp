// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:memegen/add_goods.dart';
import 'package:memegen/home_page.dart';
import 'package:memegen/payPage.dart';
import 'package:http/http.dart' as http;
import 'goods_data.dart';
import 'package:memegen/auth_page.dart';

int currentItem = 0;
String dropdownValue = 'THB';
double currencyRate = 1;
late List<int> selectedItem = [0];
int x = 0;

class SelectCategory extends StatefulWidget {
  final String userName;
  const SelectCategory({Key? key, required this.userName}) : super(key: key);
  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  int currentIndex = 0;
  double itemPrice1 = 100.00;
  PageController pageController = PageController();

  callback(newNum) {
    setState(() {
      currentItem = newNum;
    });
  }

  @override
  void initState() {
    for (int i = 0; i < itemNum; i++) {
      selectedItem.add(0);
    }
    super.initState();
  }

  callback2(newLen) {
    setState(() {
      itemNum = newLen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
      appBar: AppBar(
        title: Text("Hi ${widget.userName}"),
        actions: [
          Text(
            "${currentItem}",
            style: TextStyle(height: 2, fontFamily: 'Prompt', fontSize: 25),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => payPage(
                    currencyRate: currencyRate,
                    dropdownValue: dropdownValue,
                    selectedItem: selectedItem,
                    notifyParent_: update,
                    callback: callback,
                  ),
                ),
              );
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
                      goodsCard(current: i, notifyParent: update),
                    SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                AddGoods(notifyParents: callback2)));
                      },
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 40,
                    )
                  ],
                )
              ],
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Select currency : ",
                        style: TextStyle(fontFamily: 'Prompt', fontSize: 20),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Prompt'),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red[400])),
                    onPressed: () {
                      auth.signOut();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AuthPage()));
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
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

  void update() {
    setState(() {
      currentItem = 0;
      for (int i = 0; i < itemNum; i++) {
        currentItem += selectedItem[i];
      }
    });
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
  currency = double.parse(currency.toStringAsFixed(2));
  return currency;
}

class goodsCard extends StatefulWidget {
  final int current;
  final Function() notifyParent;
  const goodsCard({Key? key, required this.current, required this.notifyParent})
      : super(key: key);

  @override
  _goodsCardState createState() => _goodsCardState();
}

class _goodsCardState extends State<goodsCard> {
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
                  height: 10,
                ),
                Text(
                  ("${(goodsPrice[widget.current] * currencyRate).toStringAsFixed(2)} ${dropdownValue}"),
                  style: TextStyle(fontFamily: 'Prompt', fontSize: 20),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedItem[widget.current]++;
                      widget.notifyParent();
                    });
                  },
                  child: Text(
                    "Add to cart",
                    style: TextStyle(
                        fontFamily: 'Prompt', color: Colors.deepOrange),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.amber[100])),
                ),
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
