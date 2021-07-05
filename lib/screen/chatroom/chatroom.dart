import 'package:chating_app/common/color.dart';
import 'package:chating_app/common/image.dart';
import 'package:chating_app/common/string.dart';
import 'package:chating_app/helper/authenticateuser.dart';
import 'package:chating_app/helper/constraints.dart';
import 'package:chating_app/helper/sharedpref.dart';
import 'package:chating_app/screen/conversion/conversion.dart';
import 'package:chating_app/screen/search/search.dart';
import 'package:chating_app/service/database.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Center(
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomsTile(
                      username: snapshot
                          .data.documents[index].data['chatroomid']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constraints.myName, ""),
                      chatRoomId:
                          snapshot.data.documents[index].data["chatroomid"],
                    );
                  },
                ),
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

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constraints.myName = await SharedPrefFunction.getSharedPrefUserNameData();
    databaseMethods.getChatRoom(Constraints.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
    print('${StringResources.PageStart}UserName : ${Constraints.myName}');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                // Navigator.pop(context);
              },
            ),
          ),
          title: Image.asset(
            ImageResources.Logo,
            height: 40,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  goToLogin();
                },
              ),
            )
          ],
          elevation: 10,
          centerTitle: true,
        ),
        preferredSize: Size(double.infinity, height / 8),
      ),
      body: Center(child: chatRoomList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToSearch();
        },
        child: Icon(Icons.search),
      ),
    );
  }

  goToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
    setState(() {});
  }

  goToSearch() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Search()));
    setState(() {});
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  ChatRoomsTile({this.username, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Conversation(chatRoomId: chatRoomId)));
        },
        child: Container(
          color: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorResources.Blue,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    username.substring(0, 1),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Text(
                username,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
