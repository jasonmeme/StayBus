import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const EntryField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          style: TextStyle(fontSize: 12, height: 1, color: Colors.black),
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF969696)),
            ),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
          ),
        ));
  }
}
