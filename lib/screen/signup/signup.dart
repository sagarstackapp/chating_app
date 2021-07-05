import 'package:chating_app/common/color.dart';
import 'package:chating_app/common/string.dart';
import 'package:chating_app/common/widget/appbar.dart';
import 'package:chating_app/common/widget/elevatedbtn.dart';
import 'package:chating_app/common/widget/textformfield.dart';
import 'package:chating_app/helper/sharedpref.dart';
import 'package:chating_app/screen/chatroom/chatroom.dart';
import 'package:chating_app/service/auth.dart';
import 'package:chating_app/service/database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggle;

  Register(this.toggle);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  SharedPrefFunction sharedPrefFunction = SharedPrefFunction();
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        child: CommonAppBar(),
        preferredSize: Size(double.infinity, height / 8),
      ),
      body: isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                  strokeWidth: 5,
                  backgroundColor: Colors.green,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Form(
                      key: signUpFormKey,
                      child: Column(
                        children: [
                          CommonTextFormField(
                            controller: userNameController,
                            hintText: 'username',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'username can\'t be empty!';
                              }
                              if (!RegExp(r"^[a-zA-Z]+").hasMatch(value)) {
                                return 'Enter a valid username.!';
                              }
                              return null;
                            },
                          ),
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
                              textMethod('Forget Password?'),
                            ],
                          ),
                          CommonElevatedButton(
                            text: 'Sign up',
                            textColor: ColorResources.White,
                            buttonColor: ColorResources.Blue,
                            onPressed: () {
                              signUp();
                            },
                          ),
                          SizedBox(height: 20),
                          CommonElevatedButton(
                            text: 'Sign up with Google',
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
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: ColorResources.White.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'SignIn Now',
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
                          InkWell(
                            onTap: () {
                              widget.toggle();
                              // goToSignUp();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorResources.White,
                                ),
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

  void signUp() {
    final isValid = signUpFormKey.currentState.validate();
    if (isValid) {
      Map<String, String> userInfoMap = {
        'name': userNameController.text,
        'email': emailController.text,
      };

      SharedPrefFunction.saveSharedPrefUserNameData(userNameController.text);
      SharedPrefFunction.saveSharedPrefUserEmailData(emailController.text);

      setState(() {
        isLoading = true;
      });
      authService
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        print('${StringResources.PageStart}${value.toString()}');
        goToChatRoom();
      });

      databaseMethods.uploadUSerInfo(userInfoMap);
      SharedPrefFunction.saveSharedPrefUserData(true);
      signUpFormKey.currentState.save();
      print('${StringResources.PageStart}Data Saved${StringResources.PageEnd}');
      goToChatRoom();
    } else {
      print(
          '${StringResources.PageStart}Data is not acceptable${StringResources.PageEnd}');
    }
  }

  // goToLogin() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => SignIn()));
  //   setState(() {});
  // }

  goToChatRoom() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatRoom()));
    setState(() {});
  }

  textMethod(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: ColorResources.White,
        ),
      ),
    );
  }
}
