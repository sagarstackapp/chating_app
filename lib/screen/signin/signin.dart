import 'package:chating_app/common/color.dart';
import 'package:chating_app/common/string.dart';
import 'package:chating_app/common/widget/appbar.dart';
import 'package:chating_app/common/widget/elevatedbtn.dart';
import 'package:chating_app/common/widget/textformfield.dart';
import 'package:chating_app/helper/sharedpref.dart';
import 'package:chating_app/screen/chatroom/chatroom.dart';
import 'package:chating_app/service/auth.dart';
import 'package:chating_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final signInFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  QuerySnapshot snapshotUserInfo;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        child: CommonAppBar(),
        preferredSize: Size(double.infinity, height / 8),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Form(
                key: signInFormKey,
                child: Column(
                  children: [
                    CommonTextFormField(
                      controller: emailController,
                      hintText: 'email',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email can\'t be empty!';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Enter a valid email address.!';
                        }
                        return null;
                      },
                    ),
                    CommonTextFormField(
                      controller: passwordController,
                      hintText: 'password',
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password can\'t be empty!';
                        }
                        if (passwordController.text.length < 8) {
                          return 'password must be 8 character long.!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Text(
                            'Forgot Password ?',
                            style: TextStyle(
                              fontSize: 15,
                              color: ColorResources.White,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommonElevatedButton(
                      text: 'Sign in',
                      textColor: ColorResources.White,
                      buttonColor: ColorResources.Blue,
                      onPressed: () {
                        signIn();
                      },
                    ),
                    SizedBox(height: 20),
                    CommonElevatedButton(
                      text: 'Sign in with Google',
                      textColor: ColorResources.Black,
                      buttonColor: ColorResources.White,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don\'t have account? ',
                              style: TextStyle(
                                fontSize: 15,
                                color: ColorResources.White.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Register Now',
                              recognizer: TapGestureRecognizer()..onTap = () {
                                widget.toggle();
                              },
                              style: TextStyle(
                                fontSize: 15,
                                color: ColorResources.White,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signIn() {
    final isValid = signInFormKey.currentState.validate();

    if (isValid) {
      SharedPrefFunction.saveSharedPrefUserEmailData(emailController.text);

      databaseMethods.getUserByUserEmail(emailController.text).then((value) {
        snapshotUserInfo = value;
        SharedPrefFunction.saveSharedPrefUserNameData(
            snapshotUserInfo.documents[0].data['name']);
        print('SignIn Page : ${snapshotUserInfo.documents[0].data['name']}');
        print('SignIn Page : ${snapshotUserInfo.documents[0].data['email']}');
      });

      setState(() {
        isLoading = true;
      });
      authService
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        if (value != null) {
          SharedPrefFunction.saveSharedPrefUserData(true);
          print(
              '${StringResources.PageStart}Data Saved${StringResources.PageEnd}');
          goToChatRoom();
        }
      });
      signInFormKey.currentState.save();
    } else {
      print(
          '${StringResources.PageStart}Data is not acceptable${StringResources.PageEnd}');
      return null;
    }
  }

  goToChatRoom() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatRoom()));
    setState(() {});
  }
}
