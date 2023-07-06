import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_bus/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stay_bus/pages/location.dart';

class SettingsPage extends StatelessWidget {
  //final User? user;

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'First Name: ${user.firstName}',
      //         style: TextStyle(fontSize: 18.0),
      //       ),
      //       SizedBox(height: 8.0),
      //       Text(
      //         'Last Name: ${user.lastName}',
      //         style: TextStyle(fontSize: 18.0),
      //       ),
      //       SizedBox(height: 8.0),
      //       Text(
      //         'Email: ${user.email}',
      //         style: TextStyle(fontSize: 18.0),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
