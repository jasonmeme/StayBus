import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_bus/auth.dart';
import 'package:stay_bus/components/entry_field.dart';
import 'package:stay_bus/components/button.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  void signUserIn() {}

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : "Humm ? $errorMessage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F3FC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 40.0, right: 16),
                          child: const Image(
                            image:
                                AssetImage('assets/images/stay_bus_logo.png'),
                            width: 110,
                            height: 110,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120,
                      child: OverflowBox(
                        minHeight: 10,
                        maxHeight: 250,
                        child: Lottie.network(
                          'https://assets9.lottiefiles.com/packages/lf20_fgvmiyev.json',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 30),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontFamily: 'DM Serif Display',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: const Text(
                        'Welcome Back.',
                        style: TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 22.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 7),
                      child: const Text(
                        'Please Enter Your Details.',
                        style: TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 22.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 30),
                      child: const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: EntryField(
                        controller: controllerEmail,
                        hintText: "",
                        obscureText: false,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      child: const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: EntryField(
                        controller: controllerPassword,
                        hintText: "",
                        obscureText: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 12.0,
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: MyButton(
                        buttonText: "Login",
                        onTap: signUserIn,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Not a Member?',
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 15.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Register Now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
