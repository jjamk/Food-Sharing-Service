import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home/models/PostModel.dart';
import 'package:home/page/detail.dart';
import 'package:home/repository/contents_repository.dart';
import 'package:home/utils/data_utils.dart';
import 'package:home/page/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
      return <Widget> [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query="";
          },
            ),
  ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back)
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text("result"),
    );
  }
  List<String> list = List.generate(10, (index) => "search $index");
List<String> recentList = ["검색기록"];
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestList = [];
    query.isEmpty ? suggestList = recentList : suggestList.addAll(list.where(
        (element) => element.contains(query),
    ));
    return ListView.builder(
        itemCount: suggestList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              suggestList[index],
            ),
          );
        });
  }
  
}

class _HomeState extends State<Home> {
  List<PostModel> datas2 = [];

  late String currentLocation;
  ContentsRepository contentsRepository = new ContentsRepository();
  final Map<String, String> locationTypeToString = {
    "share": "무료나눔",
    "sale": "판매",
  };

  void initState() {
    // TODO: implement initState
    super.initState();
    currentLocation = "share";
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print("click");
        },
        onLongPress: () {
          print("long pressed");
        },
        child: PopupMenuButton<String>(
          offset: Offset(0,25),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),

          onSelected: (String where) {
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext  context) {
            return [
              PopupMenuItem(value: "share", child: Text("무료나눔")),
              PopupMenuItem(value: "sale", child: Text("판매")),
            ];
          },
          child: Row(
          children: [
            Text(locationTypeToString[currentLocation]!),
            Icon(Icons.arrow_drop_down,color: Colors.black ),
          ],
        ),
        ),
      ),

      elevation: 1,
      actions:[
        IconButton(onPressed: () {
          showSearch(
              context: context,
              delegate: MySearchDelegate(),
          );
        }, icon: Icon(Icons.search, color: Colors.black)),
        IconButton(onPressed: () {}, icon: Icon(Icons.tune, color: Colors.black)),
        IconButton(onPressed: () {}, icon: SvgPicture.asset("assets/svg/bell.svg",
          width: 22,)),
      ],
    );
  }

  _loadContents(){
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  Future<List<PostModel>> getPostModels() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("post");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.orderBy("foodshelf").get();

    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapShot(doc);
      datas2.add(postModel);
    }
    return datas2;
  }

  _makeDataList(List<Map<String, String>> datas) {
    getPostModels();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return DetailContentView(data: datas[index]);
            }));
          },
          child : Container(
            padding: const EdgeInsets.symmetric(vertical: 10), //위아래만 패딩
            child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Hero(
                      tag: datas[index]["cid"]!,
                      child: Image.asset(datas[index]["image"]!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas2[1].title.toString(),
                              //datas[index]["title"].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            Text(
                              datas2[1].location.toString(),
                              style: TextStyle(fontSize: 12, color: Colors.black
                                  .withOpacity(0.3)),
                            ),
                            SizedBox(height: 5),
                            Text(
                              DataUtils.calcStringToWon(datas2[1].price.toString()),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/heart_off.svg",
                                      width: 13,
                                      height: 13,
                                    ),
                                    SizedBox(width: 5),
                                    Text(datas2[1].foodshelf.toString()),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                ]
            )
        )
        );
      },
      itemCount: datas.length,
      separatorBuilder: (BuildContext _context, int index) {
        return Container(height: 1, color: Colors.black.withOpacity(0.4));
      },
    );
  }

    Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadContents(),
      builder : (BuildContext context, dynamic snapshot) {
        //로딩 처리
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        //에러 처리
        if (snapshot.hasError){
          return Center(child: Text("데이터 오류"));
        }
        if (snapshot.hasData) {
          return _makeDataList(snapshot.data);
        }
        return Center(child: Text("해당 지역에 데이터가 없습니다."));


      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body:
      _bodyWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
          post()));
        },
      )
    );
  }
}



