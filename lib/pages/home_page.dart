import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatroom_3/components/my_textfeild.dart';
import 'package:flutter_chatroom_3/pages/dm_page.dart';
import 'package:flutter_chatroom_3/pages/login_page.dart';
import 'package:flutter_chatroom_3/services/auth_service.dart';
import 'package:flutter_chatroom_3/services/login_or_register.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    LoginPage.userEmail = '';
    authService.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return LoginOrRegister();
    }));
  }

  final textController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
              title: Text('All chat'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return dmPage();
                }));
              },
            ),
            ListTile(
              title: const Text('Direct Messages'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return dmPage();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('$snapshot.error'));
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15),
                      child: Row(
                        mainAxisAlignment:
                            docs[i]['user'] == LoginPage.userEmail
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: docs[i]['user'] == LoginPage.userEmail
                                    ? Colors.grey.shade800
                                    : Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                //extract out to other method using full if statements
                                docs[i]['user'] != LoginPage.userEmail
                                    ? Column(
                                        children: [
                                          Text(
                                            '${docs[i]['user']}',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            '${docs[i]['message']}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      )
                                    : Text(
                                        '${docs[i]['message']}',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )
                              ]),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Type your message'),
              onSubmitted: (String value) {
                FirebaseFirestore.instance.collection('chat').add({
                  'message': value,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'user': LoginPage.userEmail,
                });
                textController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
