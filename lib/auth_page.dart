// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memegen/home_page.dart';
import 'package:memegen/registerpage.dart';
import 'package:memegen/selectCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late String _email, _pass, _passConfirm;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
      appBar: AppBar(
          backgroundColor: Colors.pink[200],
          title: Center(child: Text("Register/Login"))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Insert your Email",
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () async {
                  try {
                    await auth.signInWithEmailAndPassword(
                        email: _email, password: _pass);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SelectCategory(
                              userName: _email,
                            )));
                  } on FirebaseAuthException catch (e) {
                    print(e.message);
                  }
                },
                icon: Icon(Icons.login),
                label: Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal[300])),
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text(
                  "Register",
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

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      // "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      // "created_at": user.metadata.creationTime.millisecondsSinceEpoch,
      "role": "user",
      "build_number": buildNumber,
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        // "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
        "build_number": buildNumber,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
    await _saveDevice(user);
  }

  static _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String deviceId = "";
    late Map<String, dynamic> deviceData;
    if (Platform.isAndroid) {
      final deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "device": deviceInfo.name,
        "model": deviceInfo.utsname.machine,
        "platform": 'ios',
      };
    }
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMS,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMS,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMS,
        "device_info": deviceData,
      });
    }
  }
}
