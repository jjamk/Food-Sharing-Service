import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  PostModel({
    required this.title,
    required this.content,
    required this.foodshelf,
    required this.location,
    required this.price,
    //this.image
});
  String? title;
  String? content;
  String? foodshelf;
  String? location;
  String? price;

  PostModel.fromJson(dynamic json) {
    title = json['title'];
    content = json['content'];
    foodshelf = json['foodshelf'];
    location = json['location'];
    price = json['price'];
  }

  PostModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>>snapshot)
  :this.fromJson(snapshot.data());
  PostModel.fromQuerySnapShot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
  : this.fromJson(snapshot.data());

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['title'] = title;
  //   map['content'] = content;
  //   map['foodshelf'] = foodshelf;
  //   map['location'] = location;
  //   map['price'] = price;
  //
  // }
}