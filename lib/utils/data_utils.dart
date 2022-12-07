import 'package:flutter/material.dart';
import 'package:home/models/PostModel.dart';
import 'package:intl/intl.dart';

class DataUtils {
  static final oCcy = new NumberFormat("#,###", "ko_KR");
  static String calcStringToWon(String priceString) {
    //나눔
    if (priceString =="무료나눔") return priceString;
    //판매
    return "${oCcy.format(int.parse(priceString))}원";
  }
}

class currentLocations {
  static String currentSort = "default";
  static String currentLocation = "share";
  static int index2 = 0;
  static late List<PostModel> datas2 = [];
}

class currentuser {
  static String currentUserEmail = ""; //현재 사용자 메일
}