import 'package:flutter/material.dart';

import 'package:flutter_chatroom_3/components/my_button.dart';
import 'package:flutter_chatroom_3/components/my_textfeild.dart';
import 'package:flutter_chatroom_3/pages/home_page.dart';
import 'package:flutter_chatroom_3/services/login_or_register.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});
  static String userEmail= '';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          nameController.text, passwordController.text);
          LoginPage.userEmail = nameController.text;
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
          
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
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
                const Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(fontSize: 40),
                  ),
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
                    hintText: 'Email',
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
                MyButton(
                    onTap: () {
                      signIn();
                    },
                    text: 'Sign In'),
                const SizedBox(
                  height: 10,
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member? '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
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
