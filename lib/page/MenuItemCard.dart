import 'package:flutter/material.dart';
import 'submenu.dart';


class MenuItemCard extends StatelessWidget {
  final int index;
  MenuItemCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 40),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                // onTap: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => DetailPage(
                //             index: index,
                //           )));
                // },
                child: Row(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          menu[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                //width:200,
                                child: Text(
                                  menu[index].name,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),

                              ),
                              SizedBox(
                                child: Text(
                                  menu[index].content,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w300),
                                ),

                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                child: Text(
                                  "????????? " + menu[index].price.toString()+"???",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),

                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                child:                               Text(
                                  "????????? " + menu[index].saleprice.toString()+"???",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                )
,
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                width: 60,
                child: TextButton(
                  onPressed: () {},
                  child: Text("??????", style: TextStyle(color: Colors.white, fontSize: 15),),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}