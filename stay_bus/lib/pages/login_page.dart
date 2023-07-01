import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_bus/auth.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : "Humm ? $errorMessage");
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register Instead' : 'Login Instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9BCDE9),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Image(
                  image: AssetImage('assets/images/stay_bus_logo.png'),
                  width: 100,
                  height: 100,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  alignment: Alignment.center,
                  child: const Text(
                    "Welcome to StayBus",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                    child: Column(
                  children: [
                    _entryField('email', _controllerEmail),
                    _entryField('password', _controllerPassword),
                    _errorMessage(),
                    _submitButton(),
                    _loginOrRegisterButton(),
                  ],
                )),
                Lottie.network(
                  'https://assets9.lottiefiles.com/packages/lf20_fgvmiyev.json',
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
