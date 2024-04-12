import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Container(
                decoration: BoxDecoration(color: Colors.black87),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ))));
  }
}
