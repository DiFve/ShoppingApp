// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memegen/home_page.dart';
import 'auth_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email = '', _pass = '', _passConfirm = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Email", hintText: "Insert your Email"),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password", hintText: "Insert your Password"),
              onChanged: (value) {
                setState(() {
                  _pass = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Conform your Password"),
              onChanged: (value) {
                setState(() {
                  _passConfirm = value.trim();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal[300])),
                onPressed: () async {
                  if (_pass == _passConfirm && _pass != '') {
                    try {
                      await auth.createUserWithEmailAndPassword(
                          email: _email, password: _pass);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AuthPage()));
                    } on FirebaseAuthException catch (e) {
                      print(e.message);
                    }
                  } else {
                    print("Password and Confirm password does not match");
                  }
                },
                icon: Icon(Icons.add),
                label: Text(
                  "Sign up",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
