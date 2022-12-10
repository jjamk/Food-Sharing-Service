import 'package:flutter/material.dart';

import '../models/chatUsersModel.dart';
import '../screens/conversationList.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
  ChatUsers(name: "hohoing@naver.com", messageText: "안녕하세요", time: "Now"),
   // ChatUsers(name: "Jane Russel", messageText: "Awesome Setup", time: "Now"),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_rounded)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.separated(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  time: chatUsers[index].time,
                  isMessageRead: (index ==0 || index ==3)?true:false,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(height: 1, color: Colors.black.withOpacity(0.4));
              },
            ),
          ],
        ),
      ),
    );
  }
}
