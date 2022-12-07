import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:home/page/app.dart';
import 'package:home/page/LoginWithGoogle/loginWidget.dart';
import 'package:home/page/login_page.dart';


class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (!snapshot.hasData) {
            //return loginWidget();
            return loginWidget();
          }
          else {
            return App();
          }
        }
        ,
      )

    );
  }
}
