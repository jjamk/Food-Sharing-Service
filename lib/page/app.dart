import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';


class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>{
 late int _currentPageIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentPageIndex = 0;
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Container();
      case 1:
        return Home();
      case 2:
        return Container();
    }
    return Container();
}

BottomNavigationBarItem _bottomNavigationBarItem(
    String iconName, String label)
  {
    return BottomNavigationBarItem(
        icon: Padding (
          padding: const EdgeInsets.only(bottom: 5),
          child : SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 33, color: Colors.grey, ),
        ),
        activeIcon: Padding (
          padding: const EdgeInsets.only(bottom: 5),
          child : SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 33, ),
        ),
        label: label,
    );
  }

Widget _bottomNavigationBarwidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      currentIndex: _currentPageIndex,
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
        items: [
          _bottomNavigationBarItem("location", "지도"),
          _bottomNavigationBarItem("home", "홈"),
          _bottomNavigationBarItem("chat", "채팅"),

        ],
    );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarwidget(),
    );
  }
}
