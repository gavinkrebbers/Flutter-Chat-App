// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatroom_3/pages/home_page.dart';
import 'package:flutter_chatroom_3/pages/login_page.dart';
import 'package:flutter_chatroom_3/services/auth_service.dart';
import 'package:flutter_chatroom_3/services/login_or_register.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class dmPage extends StatefulWidget {
  const dmPage({super.key});

  @override
  State<dmPage> createState() => _dmPageState();
}

class _dmPageState extends State<dmPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    LoginPage.userEmail = '';
    authService.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const LoginOrRegister();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade800),
              child: const Stack(
                children: [
                  Positioned(
                      bottom: 6,
                      left: 10,
                      child: Text(
                        'Menu',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ))
                ],
              ),
            ),
            ListTile(
              title: const Text('All chat'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const HomePage();
                }));
              },
            ),
            ListTile(
              title: const Text('Direct Messages'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const dmPage();
                }));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () {
                signOut();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text('Welcome ${LoginPage.userEmail}!'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading...');
          }

          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList());
        },
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          tileColor: Colors.grey.shade900,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            data['email'],
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          trailing: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receivingUserID: data['uid'],
                          receivingUserEmail: data['email'],
                        )));
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
