import 'package:flutter/material.dart';
import 'package:home/repository/FireService.dart';
import 'package:home/repository/HomeModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton (
        onPressed: () async {
          readData();
          },
          child: const Icon(Icons.send)),
      );
  }
}

//데이터 삽입
void createData() {
  final user = FirebaseFirestore.instance.collection("post").doc("post1");
  user.set({
    "title": "제목",
    "location": "가수원동",
    "price": "30000",
    "likes": "2"
  });
}

//데이터 불러오기
void readData() {
  final user = FirebaseFirestore.instance.collection("post").doc("post1");
  user.get().then((value) => {
    print(value.data())
  });
}
