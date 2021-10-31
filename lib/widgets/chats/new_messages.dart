import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = "";
  void _sendMessage() {
    FocusScope.of(context).unfocus();
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
