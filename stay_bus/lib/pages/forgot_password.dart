import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stay_bus/components/entry_field.dart';
import 'package:stay_bus/components/button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final controllerEmail = TextEditingController();
  String? errorMessage;
  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controllerEmail.text.trim());
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context2) {
          return AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
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
      appBar: AppBar(
        backgroundColor: Color(0xFFE2F3FC),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showAlert(),
          Container(
            margin: EdgeInsets.only(top: 150),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Enter your email and we will send you a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: EntryField(
              controller: controllerEmail,
              hintText: "",
              obscureText: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: MyButton(
              buttonText: "Reset Password",
              onTap: passwordReset,
            ),
          ),
        ],
      ),
    );
  }
}
