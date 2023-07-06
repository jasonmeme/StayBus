import 'package:flutter/material.dart';
import 'package:stay_bus/auth.dart';
import 'package:stay_bus/login_or_register.dart';
import 'package:stay_bus/pages/home_page.dart';
import 'package:stay_bus/pages/template.dart';

class WidgetTreePage extends StatefulWidget {
  WidgetTreePage({Key? key}) : super(key: key);

  @override
  State<WidgetTreePage> createState() => WidgetTreeState();
}

class WidgetTreeState extends State<WidgetTreePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Template();
        } else {
          return const LoginOrSignup();
        }
      },
    );
  }
}
