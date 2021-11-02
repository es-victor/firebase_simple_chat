import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = new TextEditingController();
  String _message = "";
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    User _user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection("chat").add(
      {
        "text": _message,
        "created_at": DateTime.now(),
        "user_id": _user.uid,
      },
    );
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: TextFormField(
                controller: _messageController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Message",
                ),
                cursorWidth: 1,
                maxLines: 3,
                minLines: 1,
                expands: false,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: _message.trim().isEmpty ? null : _sendMessage,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              height: 48,
              width: 48,
              alignment: Alignment(0.2, 0),
              child: Icon(
                Icons.send_sharp,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
