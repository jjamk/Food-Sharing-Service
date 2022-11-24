import 'package:cloud_firestore/cloud_firestore.dart';

class FireService {
  static final FireService _fireService = FireService._internal();
  factory FireService() => _fireService;
  FireService._internal();

  Future createTitle(Map<String, dynamic> json) async {
    await FirebaseFirestore.instance.collection("title").add(json);
  }
}