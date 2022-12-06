import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:home/page/app.dart';
import 'package:home/page/home.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
  var foodImageFlag = false;
  var _isShareChecked = false;
  var _isSaleChecked = false;

  TextEditingController _BirthdayController =
  TextEditingController(text: " 날짜를 선택하세요");
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();

  PickedFile? _image;
  PickedFile? _foodimage;
  String postTitle = "";
  String postContent = "";
  String postPrice = "무료나눔";
  String postFoodshelf = "";
  String postKey = "";

  late String scannedText = "";
  late String filteringText = "";

  late Size size;
  late List<Image> imgList;
  late int _current;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    size = MediaQuery.of(context).size; //화면 가로 길이 받기
    _current = 0;
    imgList = [];
  }

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
            _upload();
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                App()));
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
      color: Colors.grey.withOpacity(0.3));
  }

  Future<void> _getRecognisedText(InputImage image) async {

    final TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
    final recognizedText = await textRecognizer.processImage(image);
    scannedText = recognizedText.text;
    if (scannedText.isEmpty) print("no text");
    else {
      //print(scannedText);
      filteringText = scannedText.replaceAll(RegExp('[^0-9.-]'), '').substring(0,10);
      filteringText = filteringText.replaceAll('.', '-');
    }
    foodImageFlag = false;
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
                      _selectDate();
                    },
                    child: Column(
                        children: [
                          TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              isDense: true,
                            ),
                            controller: _BirthdayController,
                            onChanged: (value) {
                              setState(() {
                                postFoodshelf = value.toString();
                              });
                            },
                          ),
                        ]
                    ))),
            SizedBox(width: 100),
            InkWell(
              child: Image.asset('assets/images/image_upload.png',
                width: 50, height: 50,
              ),
              onTap: () {
                foodImageFlag = true;
                _takeImage(context);
                _showImage();
              },
            )
          ],
        )
    );
  }

  //-------유통기한 입력--------
  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
        backgroundColor: ThemeData
            .light()
            .scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Container(
              height: 300,
              child: Column(
                children: <Widget>[
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
                        minimumYear: DateTime
                            .now()
                            .year,
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
                child: Text(
                    '갤러리에서 가져오기', style: TextStyle(color: Colors.black)),
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
    String path = image!.path;
    if (foodImageFlag) {
      await _getRecognisedText(InputImage.fromFilePath(path));
      _foodimage = image;
      imgList.add(Image.file(File(_foodimage!.path)));
    }
    else {
      _image = image;
      imgList.add(Image.file(File(_image!.path)));
    }
    setState(() {
      //_image = image!;
      _BirthdayController.text = filteringText;
    });

  }

  Widget _showImage() {
    if (_image == null)
      return Container();
    else
      return Container(
        child: Stack(
          children: [
            Hero(
              tag: postKey,
              child:
              CarouselSlider(
                options: CarouselOptions(
                  height: size.width,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    _current = index;
                  },
                ),
                items: imgList,
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: imgList.map((map) {
            //       return Container(
            //         width: 12.0,
            //         height: 12.0,
            //         margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
            //         decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: (Theme.of(context).brightness == Brightness.dark
            //                 ? Colors.white
            //                 : Colors.black)
            //                 .withOpacity(_current == int.parse(map["id"]!) ? 0.9 : 0.4)),
            //       );
            //     }).toList(),
            //   ),
            // )
          ],
        ),
      );

    // return SingleChildScrollView(
      //     //width: 300,
      //     //height: 150,
      //     child: Column(
      //       children: [
      //         Image.file(File(_image!.path)),
      //       ],
      //     )
      //
      // );
  }

  Future _upload() async {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('jpg');
    await firebaseStorageRef.putFile(File(_image!.path));

    //랜덤키 생성
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    final url = await firebaseStorageRef.getDownloadURL();
    final user = FirebaseFirestore.instance;
    postKey = getRandomString(16);

    print(_isShareChecked);

    //무료나눔
    if (_isShareChecked) {
      print("share");
      user.collection("post").doc(postKey).set({
        "postkey": postKey,
        "image": url,
        "title": postTitle,
        "foodshelf": _BirthdayController.text, //postFoodshelf,
        "location": "가수원동",
        "Content": postContent,
        "price": postPrice,
      });
    }
    //판매
    else {
      user.collection("post2").doc(postKey).set({
        "postkey": postKey,
        "image": url,
        "title": postTitle,
        "foodshelf": _BirthdayController.text, //postFoodshelf,
        "location": "가수원동",
        "Content": postContent,
        "price": postPrice,
      });
    }
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
                      controller: _titleController,
                      onChanged: (value) {
                        setState(() {
                          postTitle = value;
                        });
                      },
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
                      controller: _contentController,
                      onChanged: (value) {
                        setState(() {
                          postContent = value;
                        });
                      },
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
                        postPrice = "무료나눔";
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
                  controller: _priceController,
                  onChanged: (value) {
                    setState(() {
                      postPrice = value;
                    });
                  },
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
