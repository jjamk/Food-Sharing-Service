import 'package:flutter/material.dart';
import 'package:home/repository/HomeModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home/repository/contents_repository.dart';
import 'package:home/utils/entrance_page.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(create: (context) => EntranceProvider(), child: EntrancePage(),);

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
    print("gg"),
    print(value.data())
  });
}
