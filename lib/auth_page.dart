import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memegen/home_page.dart';
import 'package:memegen/selectCategory.dart';
import 'package:memegen/selectmeme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late String _email, _pass;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Center(child: Text("Register/Login"))),
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
          ElevatedButton.icon(
              onPressed: () async {
                try {
                  await auth.createUserWithEmailAndPassword(
                      email: _email, password: _pass);
                  // print("Register!");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SelectCategory(userName: _email)));
                } on FirebaseAuthException catch (e) {
                  print(e.message);
                }
              },
              icon: Icon(Icons.add),
              label: Text(
                "Register",
                style: TextStyle(fontSize: 20),
              )),
          ElevatedButton.icon(
              onPressed: () async {
                try {
                  await auth.signInWithEmailAndPassword(
                      email: _email, password: _pass);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SelectCategory(
                            userName: _email,
                          )));
                  // print("Login!");
                } on FirebaseAuthException catch (e) {
                  print(e.message);
                }
              },
              icon: Icon(Icons.login),
              label: Text(
                "Login",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
