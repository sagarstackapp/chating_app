import 'package:chating_app/common/color.dart';
import 'package:chating_app/common/widget/appbar.dart';
import 'package:chating_app/common/widget/textformfield.dart';
import 'package:chating_app/helper/constraints.dart';
import 'package:chating_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Conversation extends StatefulWidget {
  final String chatRoomId;

  Conversation({this.chatRoomId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController messageSendingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream<QuerySnapshot> chatMessageStream;

  get sendButton => Container(
        child: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          child: Container(
            color: ColorResources.Grey.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CommonTextFormField(
                    controller: messageSendingController,
                    hintText: 'Type a message',
                    autoFocus: false,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorResources.Grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('Send');
                      sendMessage();
                    },
                    icon: Icon(Icons.send, color: ColorResources.White),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sendByMe: Constraints.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                },
              )
            : Center(
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                    strokeWidth: 5,
                    backgroundColor: Colors.green,
                  ),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (messageSendingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageSendingController.text,
        'sendBy': Constraints.myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageSendingController.text = '';
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).then((value) {
      chatMessageStream = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        child: CommonAppBar(),
        preferredSize: Size(double.infinity, height / 8),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            sendButton,
          ],
        ),
      ),
    );
  }
}

// class MessageTile extends StatelessWidget {
//   final String message;
//
//   MessageTile(this.message);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(
//         message,
//         style: TextStyle(color: Colors.white, fontSize: 50),
//       ),
//     );
//   }
// }

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
          color: ColorResources.Blue,
        ),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
