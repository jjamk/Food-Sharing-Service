import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home/page/app.dart';
import 'package:home/page/login_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //_permission();
    //_logout();
    //_auth();
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_permission();
    //_logout();
    _auth();
  }

  @override
  void dispose(){
    super.dispose();
  }

  _permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  _auth() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Get.off(() => const LoginPage());
      }
      else {
        Get.off(() => const App());
      }
    });
  }
}
