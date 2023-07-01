import 'package:flutter/material.dart';
import 'package:stay_bus/auth.dart';
import 'package:stay_bus/pages/home_page.dart';
import 'package:stay_bus/pages/login_page.dart';

class WidgetTreePage extends StatefulWidget {
  WidgetTreePage({Key? key}) : super(key: key);

  @override
  State<WidgetTreePage> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTreePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LogInPage();
        }
      },
    );
  }
}