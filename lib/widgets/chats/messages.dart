import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chat").snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<QueryDocumentSnapshot> chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          itemBuilder: (context, i) {
            return Text(chatDocs[i]["text"]);
          },
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
