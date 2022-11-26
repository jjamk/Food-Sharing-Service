import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home/page/home.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:home/repository/contents_repository.dart';

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
  var _isShareChecked = false;
  var _isSaleChecked = false;

  TextEditingController _BirthdayController =
  TextEditingController(text: " 날짜를 선택하세요");
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();

  PickedFile? _image;


  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(onPressed: () {
        Navigator.pop(context);
      },
          icon: Icon(Icons.close, color: Colors.grey)),
      actions: [
        TextButton(onPressed: () {
          _uploadImage();
          //Navigator.pop(context);
    },
          child: Text(
              "업로드",
              style: TextStyle(
                color: Colors.black54,
                letterSpacing: 1.5,
                fontSize: 17,
              )),
        )
      ]);
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 1,
      color: Colors.grey.withOpacity(0.3),);
  }

  Widget _foodshelf() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _selectDate(); },
                  child: Column(
                      children: [
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            isDense: true,
                        ),
                          controller: _BirthdayController,
              ),
          ]
      ))),
                    SizedBox(width: 100),
                    InkWell(
                      child: Image.asset('assets/images/image_upload.png',
                      width: 50, height: 50,
                      ),
                      onTap: () => print("image upload"),
                    )
        ],
      )
    );
  }

  //-------유통기한 입력--------
  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Container(
              height:300,
              child: Column(
                children: <Widget> [
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CupertinoButton(
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.pop(context);
                                FocusScope.of(context).unfocus();
                              }),
                          CupertinoButton(
                              child: Text('완료'),
                              onPressed: () {
                                Navigator.of(context).pop(tempPickedDate);
                                FocusScope.of(context).unfocus();
                              }),
                        ],
                      )
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  Expanded(
                      child: CupertinoDatePicker(
                        minimumYear: DateTime.now().year,
                        minimumDate: DateTime.now(),
                        initialDateTime: DateTime.now(),

                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (DateTime dateTime) {
                          tempPickedDate = dateTime;
                        },
                      ))
                ],
              )
          );
        });
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _BirthdayController.text = pickedDate.toString();
        convertDateTimeDisplay(_BirthdayController.text);
      });
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    return _BirthdayController.text = serverFormater.format(displayDate);
  }

  //-------이미지 업로드--------

  _takeImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            title: Text('사진 업로드', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
            children: [
              SimpleDialogOption(
                child: Text('카메라로 촬영하기', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
              ),
              SimpleDialogOption(
                child: Text('갤러리에서 가져오기', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                child: Text('취소', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Future getImage(ImageSource imageSource) async {
    Navigator.pop(context);
    var image = await ImagePicker.platform.pickImage(source: imageSource);
    setState(() {
      _image = image!;
    });
  }

  Widget _showImage() {
    if (_image == null)
      return Container();
    else
    return Container(
      width: 300,
      height: 150,
      child:
      Image.file(File(_image!.path))
      );
  }

  Future _uploadImage() async {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('jpg');
    await firebaseStorageRef.putFile(File(_image!.path));

    final url = await firebaseStorageRef.getDownloadURL();
    final user = FirebaseFirestore.instance.collection("post").doc("post1");
    user.set({
      "title": "제목",
      "location": "가수원동",
      "price": "30000",
      "likes": url,
    });


  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //이미지 업로드
          IconButton(onPressed: () {
            _takeImage(context);
          }, icon: Image.asset('assets/images/image_upload.png')),
          _showImage(),
          _line(),
          //제목
          Container(
            padding: EdgeInsets.all(4.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '제목',
                )
              )
          ),
          _line(),
          //유통기한
          _foodshelf(),
          _line(),
          //내용
          Container(
                padding: EdgeInsets.all(4.0),
                child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                      labelText: '내용을 입력하세요',
                    )
                )
            ),

          _line(),
          //거래종류
          Container(
            padding: EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("무료나눔", style: TextStyle(fontSize: 15),),
                Checkbox(value: _isShareChecked, onChanged: (value) {
                  setState(() {
                    _isShareChecked = value!;
                    if (_isSaleChecked)
                      _isSaleChecked = false;
                  });
                }),
                SizedBox(width: 50),
                Text("판매", style: TextStyle(fontSize: 15)),
                Checkbox(value: _isSaleChecked, onChanged: (value) {
                  setState(() {
                    _isSaleChecked = value!;
                    if (_isShareChecked)
                      _isShareChecked = false;
                  });
                }),


              ],
            ),
          ),
          _line(),
          Visibility(
              child: TextField(
              decoration:
              InputDecoration(border: OutlineInputBorder(),
              labelText: '판매할 가격'),
              ),
            visible: _isSaleChecked,
          ),
        ],
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),

      //bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
