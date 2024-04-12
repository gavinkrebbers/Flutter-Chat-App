import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  const MyTextFeild(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration:  InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey)

              
              ),
              
    );
  }
}
