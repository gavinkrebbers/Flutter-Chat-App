import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatroom_3/pages/home_page.dart';
import 'package:flutter_chatroom_3/pages/login_page.dart';
import 'package:flutter_chatroom_3/services/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
  
      builder: (context, snapshot){
        if(snapshot.hasData)
        {
          return  const HomePage();
        }
        else
        {
          return const LoginOrRegister();
        }
      } ,),
    );
  }
}