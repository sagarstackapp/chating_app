import 'package:chating_app/screen/signin/signin.dart';
import 'package:chating_app/screen/signup/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isLogIN = true;

  void toggleView() {
    setState(() {
      isLogIN = !isLogIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogIN ? SignIn(toggleView) : Register(toggleView);
  }
}