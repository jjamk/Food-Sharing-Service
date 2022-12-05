import 'dart:async';

import 'package:home/models/ChattingModel.dart';
import 'package:home/screens/chatting_page/local_utils/ChattingProvider.dart';
import 'package:home/screens/chatting_page/local_widgets/chatting_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChattingPage extends StatefulWidget {
  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late TextEditingController _controller;
  late StreamSubscription _streamSubscription;

  bool firstLoad = true;
  
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    var p = Provider.of<ChattingProvider>(context, listen: false);
    _streamSubscription = p.getSnapshot().listen((event) {
      if(firstLoad) {
        firstLoad = false;
        return;
      }
      p.addOne(ChattingModel.fromJson(event.docs[0].data()as Map<String,dynamic>));
    });
    Future.microtask(() {
      p.load();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<ChattingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_rounded,
            color: Colors.black,)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              children: p.chattingList.map((e) => ChattingItem(chattingModel: e)).toList(),
            ),
          ),
          Divider(
            thickness: 1.5,
            height: 1.5,
            color: Colors.grey[300],
          ),
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .5),
            margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 27),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '텍스트 입력',
                          hintStyle: TextStyle(color: Colors.grey[400])),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    var text = _controller.text;
                    _controller.text = '';
                    p.send(text);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Icon(
                      Icons.send,
                      size: 33,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
