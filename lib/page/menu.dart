import 'package:flutter/material.dart';
import 'package:home/page/MenuItemCard.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: true,
      ),
      body:
      SingleChildScrollView(
        child:Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: height*0.2,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/subway.jpeg"),
                            fit: BoxFit.cover
                        )
                    ),

                  )
                ],
              ),
              Transform.translate(
                offset: Offset(0.0, -(height *0.3 - height *0.26) ),
                child: Container(
                    width:width,
                    //height: 400,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )
                    ),
                    child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: <Widget>[
                            Text(
                              '써브웨이 관저점',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.left,

                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Padding(
                            //     padding: const EdgeInsets.only(left:20, right: 20,bottom: 10),
                            //     child: TextField(
                            //       decoration: InputDecoration(
                            //           contentPadding:
                            //           EdgeInsets.symmetric(vertical:3),
                            //           prefixIcon: Padding(
                            //             padding: const EdgeInsets.only(
                            //                 left:15, right: 15),
                            //             child: Icon(
                            //               Icons.search,
                            //               size: 30,
                            //             ),
                            //           ),
                            //           hintText: "음식을 검색하세요",
                            //           border: OutlineInputBorder(
                            //               borderRadius: BorderRadius.circular(30),
                            //               borderSide: BorderSide(
                            //                   width: 1.0, color: Colors.grey)
                            //           )
                            //
                            //       ),
                            //     )
                            // ),
                            SingleChildScrollView(
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView(
                                    children: <Widget>[
                                      MenuItemCard(index: 0,),
                                      MenuItemCard(index: 1),
                                    ],
                                  ),
                                ) )],

                        )

                    ),
                  ),

              )
            ],
          ),
        ),
      ),
    );
  }
}

