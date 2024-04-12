import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatroom_3/chat/chat_service.dart';
import 'package:flutter_chatroom_3/chat/message.dart';
import 'package:flutter_chatroom_3/components/my_textfeild.dart';
import 'package:flutter_chatroom_3/pages/home_page.dart';

class ChatPage extends StatefulWidget {
  final String receivingUserEmail;
  final String receivingUserID;
  const ChatPage(
      {super.key,
      required this.receivingUserID,
      required this.receivingUserEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receivingUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.receivingUserEmail),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  onSubmitted: (value) => sendMessage(),
                  controller: _messageController,
                  decoration: InputDecoration(
                      hintText: 'Enter Message',
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10))),
                )),
                IconButton(
                    onPressed: sendMessage, icon: Icon(Icons.arrow_upward))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool alignRight = false;
    if (data['senderID'] == _firebaseAuth.currentUser!.uid.toString()) {
      alignRight = true;
    }
    return Container(
        alignment:
            alignRight == true ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: alignRight == true
                        ? Colors.grey.shade800
                        : Colors.blue),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['message'],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: ChatService()
          .getMessages(widget.receivingUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
}

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController textController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   void sendMessage() async {
//     if (textController.text != '') {
//       await _chatService.sendMessage(
//           widget.receivingUserEmail, textController.text);
//       textController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.receivingUserEmail),
//         backgroundColor: Colors.grey.shade900,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: textController,
//                 decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Type your message'),
//                 onSubmitted: (String value) {
//                   sendMessage();
//                 },
//               ),
//             ),
//           ),

//           // _buildMessageInput();
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageList() {
//     return StreamBuilder(
//       stream: _chatService.getMessages(
//           _firebaseAuth.currentUser!.uid, widget.receivingUserID),
//       builder: (context, snapshot) {
//         if(snapshot.hasError)
//         {
//           return Text('Error');
//         }
//         if(snapshot.connectionState == ConnectionState.waiting)
//         {
//           return Text('Loading');
//         }

         
//         return ListView(
//           children: snapshot.data!.docs.map((document) => _buildMessageItem(docs))
//           );
//       },
//     );
//   }
//   Widget _buildMessageItem(DocumentSnapshot document){
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
     
//      return Column(children: [Text(data['senderEmail']),Text(data['message']) ],);
//   }
//}
