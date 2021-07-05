import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection('user')
        .where('name', isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String email) async {
    return await Firestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  uploadUSerInfo(userMap) {
    Firestore.instance.collection('user').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessage(String charRoomId, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(charRoomId)
        .collection('Chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessage(String charRoomId) async {
    return await Firestore.instance
        .collection('chatroom')
        .document(charRoomId)
        .collection('Chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  getChatRoom(String username) async {
    return await Firestore.instance
        .collection("chatroom")
        .where('users', arrayContains: username)
        .snapshots();
  }
}
