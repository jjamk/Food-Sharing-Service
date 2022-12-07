import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home/models/PostModel.dart';
import 'package:home/page/detail.dart';
import 'package:home/page/LoginWithGoogle/login.dart';
import 'package:home/page/login_page.dart';
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
  static late int current_index=0;
  //static late String currentLocation;
  ContentsRepository contentsRepository = new ContentsRepository();
  final Map<String, String> locationTypeToString = {
    "share": "무료나눔",
    "sale": "판매",
  };
  final Map<String, String> sortTypeToString = {
    "default": "최신순",
    "foodshelf": "유통기한순",
  };

  void initState() {
    // TODO: implement initState
    super.initState();
    getPostModels();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.lightGreen,
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
              currentLocations.currentLocation = where;
              getPostModels();
              print(currentLocations.currentLocation);
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
            Text(locationTypeToString[currentLocations.currentLocation]!),
            Icon(Icons.arrow_drop_down, color: Colors.white ),
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
        }, icon: Icon(Icons.search, color: Colors.white)),
        PopupMenuButton<String>(
          offset: Offset(0,40),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              1),

          onSelected: (String where) {
            setState(() {
              currentLocations.currentSort = where;
            });
          },
          itemBuilder: (BuildContext  context) {
            return [
              PopupMenuItem(value: "default", child: Text("최신순")),
              PopupMenuItem(value: "foodshelf", child: Text("유통기한순")),
            ];
          },
          child: Row(
            children: [
              Icon(Icons.tune, color: Colors.white ),
            ],
          ),
        ),
        // IconButton(onPressed: () {
        // }, icon: Icon(Icons.tune, color: Colors.black)),
        //IconButton(onPressed: () {}, icon: SvgPicture.asset("assets/svg/bell.svg",
        //  width: 22,)),
      ],
    );
  }

  _loadContents() {
    //await Future.delayed(Duration(seconds: 1));
    return contentsRepository.loadContentsFromLocation(currentLocations.currentLocation);
  }

  Future<List<PostModel>> getPostModels() async {
    currentLocations.datas2=[];
    CollectionReference<Map<String, dynamic>> collectionReference;

    if (currentLocations.currentLocation == "share") {
      collectionReference =
      FirebaseFirestore.instance.collection("post");
    }
    else {
      collectionReference =
      FirebaseFirestore.instance.collection("post2");
      print('hey');
    }
    //최신순(기본값)
    if (currentLocations.currentSort == "default") {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await collectionReference.orderBy("postkey", descending: true).get();
      for (var doc in querySnapshot.docs) {
        PostModel postModel = PostModel.fromQuerySnapShot(doc);
        currentLocations.datas2.add(postModel);
      }
    }
    //유통기한 임박순으로 정렬
    else {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await collectionReference.orderBy("foodshelf",).get();
      for (var doc in querySnapshot.docs) {
        PostModel postModel = PostModel.fromQuerySnapShot(doc);
        currentLocations.datas2.add(postModel);
      }
    }
    current_index = currentLocations.datas2.length;

    return currentLocations.datas2;
  }

  _makeDataList(List<Map<String, String>> datas) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: () {
            currentLocations.index2=index;
            print('index is ${currentLocations.index2}');
            print('current is ${currentLocations.currentLocation}');
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DetailContentView()));
          },
          child : Container(
            padding: const EdgeInsets.symmetric(vertical: 10), //위아래만 패딩
            child: SingleChildScrollView(
                child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: Hero(
                          tag: currentLocations.datas2[index],//datas2[index]["cid"]!,
                          child: Image.network(currentLocations.datas2[index].image.toString(),
                            width: 100,
                            height: 100,
                            //fit: BoxFit.fill,
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
                                  currentLocations.datas2[index].title.toString(),
                                  //datas[index]["title"].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  currentLocations.datas2[index].location.toString(),
                                  style: TextStyle(fontSize: 12, color: Colors.black
                                      .withOpacity(0.3)),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  DataUtils.calcStringToWon(currentLocations.datas2[index].price.toString()),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        // SvgPicture.asset(
                                        //   "assets/svg/heart_off.svg",
                                        //   width: 13,
                                        //   height: 13,
                                        // ),
                                        // SizedBox(width: 5),
                                        Text('${currentLocations.datas2[index].foodshelf.toString()}까지'),
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

            ),
        )
        );
      },
      itemCount: currentLocations.datas2.length,
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
      //   if (current_index == 0)
      //     {
      //       getPostModels();
      //     }

      if (snapshot.connectionState != ConnectionState.done) {
      return Center(child: CircularProgressIndicator());
      }
        //에러 처리
        if (snapshot.hasError){
          return Center(child: Text("데이터 오류"));
        }
        if (currentLocations.datas2.length == 0)
          return Center(child: Text("게시된 글이 없습니다."));
        //새 글이 올라왔을 때
      if (currentLocations.datas2.length != current_index)
        {
          getPostModels();
          print(currentLocations.datas2.length);
          print("new");
          //print(current_index);
          return _makeDataList(snapshot.data);
        }
      //새 글이 올라오지 않았을 때
       if (snapshot.hasData) {
         print(current_index);
         print("no new");
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('${currentuser.currentUserEmail}님',
              style: TextStyle(color: Colors.black)),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                radius: 25,
                backgroundImage: Image.asset("assets/images/user.png").image,
                backgroundColor: Colors.transparent,),
              // onDetailsPressed: () {
              //   print('arrow is clicked');
              // },
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0))),
                ),
      TextButton(
          onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
          child: Text("로그아웃"),
              ),
          ],
        ),
      ),
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



