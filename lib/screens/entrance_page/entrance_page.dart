import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:home/screens/chatting_page/chatting_page.dart';
import 'package:home/screens/chatting_page/local_utils/ChattingProvider.dart';
import 'package:uuid/uuid.dart';

class EntrancePage extends StatefulWidget{
  @override
  _EntrancePageState createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '닉네임 입력',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                var u = const Uuid().v1();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider(
                          create: (context) => ChattingProvider(u, _controller.text),
                          child: ChattingPage(),
                        )));
              },
              child: Container(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text("방 입장하기", style: TextStyle(fontSize: 25),)),
            ),
          ],
        ),
      ),
    );
  }
}