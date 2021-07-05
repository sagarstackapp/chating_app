import 'package:chating_app/common/color.dart';
import 'package:chating_app/helper/authenticateuser.dart';
import 'package:chating_app/helper/sharedpref.dart';
import 'package:chating_app/screen/chatroom/chatroom.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLogIn = false;

  @override
  void initState() {
    // getLogIn();
    super.initState();
  }

  getLogIn() async {
    await SharedPrefFunction.getSharedPrefUserData().then((value) {
      setState(() {
        userLogIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorResources.ScaffoldColor,
      ),
      debugShowCheckedModeBanner: false,
      home: userLogIn ? ChatRoom() : Authenticate(),
    );
  }
}
