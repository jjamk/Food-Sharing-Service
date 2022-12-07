import 'package:flutter/material.dart';
import 'package:home/repository/HomeModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home/repository/contents_repository.dart';
import 'package:home/screens/chatting_page/chatting_page.dart';
import 'package:home/screens/chatting_page/local_utils/ChattingProvider.dart';
import 'package:home/utils/data_utils.dart';
import 'package:home/utils/entrance_page.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  //ContentsRepository contentsRepository = new ContentsRepository();

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  chat () {
    var u = const Uuid().v1();

    // Navigator.pop(context);
   // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider(
              create: (context) => ChattingProvider(u, currentuser.currentUserEmail),
              child: ChattingPage(),
            )));
  }

  @override
  Widget build(BuildContext context) {

    var u = const Uuid().v1();
   // return chat();
    return ChangeNotifierProvider( create: (context) => ChattingProvider(u, currentuser.currentUserEmail), child: ChattingPage(),);

    // return Container(
    //   child: Image.network(contentsRepository.datas[0]["image"],
    //   width: 100,height: 100, fit:BoxFit.fill)
    //   // child: TextButton (
    //   //   onPressed: () async {
    //   //     createData();
    //   //     },
    //   //      child: const Icon(Icons.send)),
    //   );
  }
}
