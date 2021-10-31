import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_app/widgets/chats/messages.dart';
import 'package:first_firebase_app/widgets/chats/new_messages.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Text('Logout'),
                  ],
                ),
                value: 1,
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage()
          ],
        ),
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection("chats/UhsST5tbiJF8Z7VkwkI6/messages")
      //       .snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshots) {
      //     if (streamSnapshots.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     final List<QueryDocumentSnapshot<dynamic>> docs =
      //         streamSnapshots.data!.docs;
      //     return ListView.builder(
      //       itemBuilder: (context, i) {
      //         return Text(docs[i]["text"]);
      //       },
      //       itemCount: docs.length,
      //     );
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection("chats/UhsST5tbiJF8Z7VkwkI6/messages")
      //         .add({"text": "Added from mobile app"});
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
