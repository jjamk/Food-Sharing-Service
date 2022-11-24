import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home/page/home.dart';

class HomeModel {
  late String title;
  // late String location;
  // late String price;
  // late int likes;
  DocumentReference? reference;

  HomeModel({
    required this.title,
    // required this.location,
    // required this.price,
    // required this.likes,
    this.reference
});

  //firestore에서 값을 불러올 떄
  HomeModel.fromJson(dynamic json, this.reference) {
    title = json['title'];
    // location = json['location'];
    // price = json['price'];
    // likes = json['likes'];
  }

  //특정 도큐먼트의 위치
  HomeModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
  : this.fromJson(snapshot.data(), snapshot.reference);

  //특정 콜렉션안에 있는 도큐먼트를 가져올 때
  HomeModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot
      ) : this.fromJson(snapshot.data(), snapshot.reference);

  //파이어베이스로 저장
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    // map['location'] = 'location';
    // map['price'] = 'price';
    // map['likes'] = 'likes';
    return map;
  }

}