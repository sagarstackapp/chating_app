import 'package:chating_app/common/color.dart';
import 'package:chating_app/common/widget/appbar.dart';
import 'package:chating_app/common/widget/textformfield.dart';
import 'package:chating_app/helper/constraints.dart';
import 'package:chating_app/screen/conversion/conversion.dart';
import 'package:chating_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  final TextEditingController searchController = TextEditingController();

  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    // initialSearch();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ColorResources.Grey.withOpacity(0.8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CommonTextFormField(
                        controller: searchController,
                        hintText: 'enter username'),
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
                        print('search');
                        initialSearch();
                      },
                      icon: Icon(Icons.search, color: ColorResources.White),
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }

  initialSearch() {
    databaseMethods.getUserByUsername(searchController.text).then((value) {
      print(searchController.text);
      print(value.toString());
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  createChatRoom(String userName) {
    String chatRoomId = getChatRoomId(userName, Constraints.myName);
    List<String> user = [userName, Constraints.myName];
    Map<String, dynamic> chatRoomMap = {
      'users': user,
      'chatroomid': chatRoomId,
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId: chatRoomId,)));
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      color: ColorResources.White,
                      fontSize: 15,
                      wordSpacing: 2,
                      letterSpacing: 1,
                      height: 3,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: ColorResources.Grey,
                      fontSize: 15,
                      wordSpacing: 2,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                createChatRoom(userName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorResources.Blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text('Message',
                      style: TextStyle(color: ColorResources.White)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.documents[index].data['name'],
                userEmail: searchSnapshot.documents[index].data['email'],
              );
            })
        : Container(child: Text('null'));
  }



  // goToConversation() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => Conversation(chatRoomId: chatRoomId,)));
  //   setState(() {});
  // }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
