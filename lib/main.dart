import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:home/firebase_options.dart';
import 'package:home/page/app.dart';
import 'package:home/page/LoginWithGoogle/loginWidget.dart';
import 'package:home/page/login_page.dart';
import 'package:home/page/LoginWithGoogle/login.dart';
import 'package:home/page/my_home_page.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Sharing',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle:  TextStyle(color: Colors.black)
        ),
        primaryColor:Colors.black,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', ''),
        Locale(' en', ''),
      ],
      home: MyHomePage(),
      //App(),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flutter Firebase")),
//       body: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text("Google Sign-In Demo"),
//             subtitle: Text("google_sign_in Plugin"),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => loginWidget()));
//             },
//           ),
//           ListTile(
//             title: Text("Firebase Auth"),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => A()));
//             },
//           )
//         ].map((child) {
//           return Card(
//             child: child,
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
