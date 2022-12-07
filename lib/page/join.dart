import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:home/page/app.dart';
import 'package:home/page/join_page.dart';
import 'package:home/page/LoginWithGoogle/loginWidget.dart';


class join extends StatelessWidget {
  const join({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: join_page(),
    );
  }
}
