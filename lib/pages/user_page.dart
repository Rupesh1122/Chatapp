import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp/pages/chat_services.dart';

class UserPage extends StatefulWidget {
  final String phone;
  final String receiverId;
  const UserPage({super.key, required this.phone, required this.receiverId});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMesssage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverId, messageController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.phone.text.make(),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(
          widget.receiverId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...").centered();
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Container(
            // ignore: sort_child_properties_last
            child: data['message']
                .toString()
                .text
                .color(Colors.white)
                .make()
                .p12(),
            decoration: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
          )
        ],
      ).p12(),
    );
  }

  Widget buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'Enter message',
            ),
          ),
        ),
        IconButton(
            onPressed: sendMesssage, icon: const Icon(Icons.arrow_upward))
      ],
    );
  }
}
