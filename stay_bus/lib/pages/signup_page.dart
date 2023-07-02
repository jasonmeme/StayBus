import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_bus/auth.dart';
import 'package:stay_bus/components/entry_field.dart';
import 'package:stay_bus/components/button.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;
  const SignUpPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? errorMessage;

  bool isLogin = true;
  final controllerEmail = TextEditingController();
  final controllerFirstName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerPassword = TextEditingController();
  final bool checkBoxValue = false;

  UserCredential? userCredential;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerFirstName.dispose();
    controllerLastName.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      final UserCredential newCredential =
          await Auth().createUserWithEmailAndPassword(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      setState(() {
        userCredential = newCredential;
      });
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      setState(() {
        errorMessage = e.message;
      });
    }

    if (userCredential != null) {
      addUserDetails(
          controllerFirstName.text.trim(),
          controllerLastName.text.trim(),
          controllerEmail.text.trim(),
          checkBoxValue);
    }
  }

  Future addUserDetails(
      String firstName, String lastName, String email, bool driver) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'driver': driver,
    });
  }

  Widget showAlert() {
    if (errorMessage != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(errorMessage == '' ? '' : "$errorMessage"),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(
                  () {
                    errorMessage = null;
                  },
                );
              },
            ),
          ],
        ),
      );
    }
    return const SizedBox(height: 0);
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
                    SizedBox(height: 40),
                    showAlert(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 20.0, right: 16),
                          child: const Image(
                            image:
                                AssetImage('assets/images/stay_bus_logo.png'),
                            width: 110,
                            height: 110,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontFamily: 'DM Serif Display',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: const Text(
                        'New Here?',
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
                        'First Name',
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
                        controller: controllerFirstName,
                        hintText: "",
                        obscureText: false,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: const Text(
                        'Last Name',
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
                        controller: controllerLastName,
                        hintText: "",
                        obscureText: false,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
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
                      margin: const EdgeInsets.only(left: 20, top: 10),
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
                      margin: const EdgeInsets.only(top: 30),
                      child: MyButton(
                        buttonText: "Sign Up",
                        onTap: createUserWithEmailAndPassword,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 15.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}
