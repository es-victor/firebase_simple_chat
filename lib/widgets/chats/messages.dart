import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_app/utils/remove_scroll_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _messageListController = new ScrollController();
  String _userID = "";
  @override
  void initState() {
    getCurrentUserID();
    super.initState();
  }

  @override
  void dispose() {
    _messageListController.dispose();
    super.dispose();
  }

  getCurrentUserID() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    if (uid != "") {
      setState(() {
        _userID = uid;
      });
    }
  }

  String _dateTimeHM(Timestamp dateTimeStamp) {
    DateTime date = dateTimeStamp.toDate();
    var a = DateFormat('Hm', 'en_US').format(date);
    return a.toString();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        final List<QueryDocumentSnapshot> chatDocs = chatSnapshot.data!.docs;

        if (_userID == "" ||
            chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (chatSnapshot.hasData == false) {
          return Center(
            child: Text("No chat messages"),
          );
        }
        return removeScrollGlow(
          enable: true,
          listChild: ListView.builder(
            reverse: true,
            controller: _messageListController,
            itemBuilder: (context, i) {
              return MessageBubble(
                text: chatDocs[i]["text"],
                time: _dateTimeHM(
                  chatDocs[i]["created_at"],
                ),
                isFromMe: chatDocs[i]["user_id"] == _userID,
                key: ValueKey(
                  chatDocs[i]["created_at"],
                ),
              );
            },
            itemCount: chatDocs.length,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isFromMe;

  const MessageBubble({
    Key? key,
    required this.text,
    required this.time,
    required this.isFromMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                      color: isFromMe
                          ? Theme.of(context).primaryColor.withOpacity(0.05)
                          : Colors.orange.shade100.withOpacity(0.1),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                            isFromMe ? Radius.circular(16) : Radius.zero,
                        bottomRight:
                            isFromMe ? Radius.zero : Radius.circular(16),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )
                      // borderRadius: BorderRadius.circular(16),
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  text,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    time,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
