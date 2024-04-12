import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatroom_3/components/my_button.dart';
import 'package:flutter_chatroom_3/components/my_textfeild.dart';
import 'package:flutter_chatroom_3/pages/home_page.dart';
import 'package:flutter_chatroom_3/pages/login_page.dart';
import 'package:flutter_chatroom_3/services/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void signUp() async {
    if (passwordController.text == confirmPasswordController.text) {
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signUpWithEmailAndPassword(
            nameController.text, passwordController.text);
            LoginPage.userEmail = nameController.text;
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Create An Account',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),

                const Icon(
                  Icons.chat,
                  size: 160,
                ),

                const SizedBox(
                  height: 20,
                ),

                MyTextFeild(
                    controller: nameController,
                    hintText: 'User Name',
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextFeild(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyTextFeild(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true),

                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    onTap: () {
                      signUp();
                    },
                    text: 'Sign Up'),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member?'),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        ' Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )

                //register button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
