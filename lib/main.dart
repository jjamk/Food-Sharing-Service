import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home/page/app.dart';

void main() async{
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle:  TextStyle(color: Colors.black)
        ),
        primaryColor:Colors.black,

      ),
      home: App(),
    );
  }
}