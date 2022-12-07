import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home/page/app.dart';
import 'package:home/page/home.dart';
import 'package:home/page/join.dart';
import 'package:home/page/join_page.dart';
import 'package:home/page/LoginWithGoogle/loginWidget.dart';
import 'package:home/utils/auth_utils.dart';
import 'package:home/utils/data_utils.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _userIdWidget() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
      ),
      validator: (String? value) {
        if (value!.isEmpty)
          return '이메일을 입력해주세요';
        return null;
      },
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
      validator: (String? value) {
        if (value!.isEmpty)
          return '비밀번호를 입력해주세요';
        return null;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _userIdWidget(),
            SizedBox(height: 20,),
            _passwordWidget(),
            Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.only(top:8.0),
              child: ElevatedButton(
                onPressed: () => _login(),
                child: Text("로그인"),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.only(top:8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => join()));
                },
                child: Text("회원가입"),
              ),
            ),
          ],
        ),
      )
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _login() async {
    //키보드 숨기기
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      // Firebase 사용자 인증, 사용자 등록
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        currentuser.currentUserEmail = _emailController.text;
        print(_emailController.text);
        Get.offAll(() =>
          const App());
      } on FirebaseAuthException catch (e) {
        //logger.e(e);
        String message = '';

        if (e.code == 'user-not-found') {
          message = '사용자가 존재하지 않습니다.';
        } else if (e.code == 'wrong-password') {
          message = '비밀번호를 확인하세요';
        } else if (e.code == 'invalid-email') {
          message = '이메일을 확인하세요.';
        }

        /*final snackBar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.deepOrange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      */

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }
}
