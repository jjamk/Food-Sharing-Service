import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home/page/chat.dart';
import 'package:home/utils/data_utils.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late Size size;
  late List<Map<String,String>> imgList;
  late int _current;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    size = MediaQuery.of(context).size; //화면 가로 길이 받기
    _current = 0;
    imgList = [
      {"id": "0", "url": widget.data["image"]!},
      {"id": "1", "url": widget.data["image"]!},
      {"id": "2", "url": widget.data["image"]!},
      {"id": "3", "url": widget.data["image"]!},
      {"id": "4", "url": widget.data["image"]!},
    ];
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(onPressed: () {
        Navigator.pop(context);
      },
          icon: Icon(Icons.arrow_back, color: Colors.white,)), //뒤로가기
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.share, color: Colors.white)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  Widget _makeSliderImage() {
     return Container(
       child: Stack(
         children: [
           Hero(
             tag: widget.data["cid"]!,
             child:
             CarouselSlider(
               options: CarouselOptions(
                 height: size.width,
                 initialPage: 0,
                 enableInfiniteScroll: false,
                 viewportFraction: 1,
                 onPageChanged: (index, reason) {
                   _current = index;
                 },
               ),
               items: imgList.map(
                       (map) {
                     return Image.asset(
                       map["url"]!,
                       width: size.width,
                       fit: BoxFit.fill,
                     );
                   }).toList(),
             ),
           ),
           Positioned(
             bottom: 0,
             left: 0,
             right: 0,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: imgList.map((map) {
                 return Container(
                   width: 12.0,
                   height: 12.0,
                   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                   decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: (Theme.of(context).brightness == Brightness.dark
                           ? Colors.white
                           : Colors.black)
                           .withOpacity(_current == int.parse(map["id"]!) ? 0.9 : 0.4)),
                 );
               }).toList(),
             ),
           )
         ],
       ),
     );
  }

  Widget _sellerSimpleInfo() {
    return Row(
      children: [
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(50),
        //   child: Container(
        //     width: 50, height: 50, child: Image.asset("assets/images/user.png"),
        //   ),
        // )
        CircleAvatar(
          radius: 25,
          backgroundImage: Image.asset("assets/images/user.png").image,
          backgroundColor: Colors.transparent,),
        SizedBox(width:10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "지구사랑",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                )
            ),
            Text(
                "대전 가수원동"
            ),
          //매너온도는 강의 #9 에서
          ],
        )
      ],
    );
  }
  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 1,
      color: Colors.grey.withOpacity(0.3),);
  }
  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.data["title"]!,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
            ),
          ),
          Text(
            "유통기한",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            "이거 정말~ 맛있습니다",
            style: TextStyle(
              fontSize: 15,
              height: 2
            ),
          )
        ],
      ),
    );
  }
  Widget _bodyWidget() {
    return SingleChildScrollView( //스크롤기능
      child: Column(
          children : [
            _makeSliderImage(),
            SizedBox(height: 10),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            //같은 판매자가 판매중인 다른 상품 보기 #10
          ]
      ),

    );
  }

  Widget _bottomBarWidget() {
    return Container (
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
            },
            child: SvgPicture.asset(
              "assets/svg/heart_off.svg",
              width: 20,
              height: 20,
            ),

          ),
          Container(
            margin: const EdgeInsets.only(left:15, right:10),
            width:  1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            children: [
              SizedBox(height: 12),
              Text(
                  DataUtils.calcStringToWon(widget.data["price"]!),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  )),
            ],
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return ChatView();
                      }));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5),
                        color:  Colors.green,),
                      child: Text(
                        "채팅하기",
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 16, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  )
                ],
              )

    )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appbarWidget(),
        body: _bodyWidget(),
        bottomNavigationBar: _bottomBarWidget(),
      );
    }
}
