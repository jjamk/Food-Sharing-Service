class ContentsRepository {
  Map<String, dynamic>datas= {
    "share":[
      {
        "cid": "1",
        "image": "assets/images/food2.png",
        "title": "네메시스 축구화275",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "2"
      },
      {
        "cid": "2",
        "image": "assets/images/food1.jpeg",
        "title": "LA갈비 5kg팔아요~",
        "location": "제주 제주시 아라동",
        "price": "무료나눔",
        "likes": "5"
      },
      {
        "cid": "3",
        "image": "assets/images/img3.jpeg",
        "title": "치약팝니다",
        "location": "제주 제주시 아라동",
        "price": "5000",
        "likes": "0"
      },
  ],
    "sale": [
      {
        "cid": "4",
        "image": "assets/images/img4.jpeg",
        "title": "[풀박스]맥북프로16인치 터치바 스페이스그레이",
        "location": "제주 제주시 아라동",
        "price": "2500000",
        "likes": "6"
      },
      {
        "cid": "5",
        "image": "assets/images/img5.jpeg",
        "title": "디월트존기임팩",
        "location": "제주 제주시 아라동",
        "price": "150000",
        "likes": "2"
      },
      {
        "cid": "6",
        "image": "assets/images/img6.jpeg",
        "title": "갤럭시s10",
        "location": "제주 제주시 아라동",
        "price": "180000",
        "likes": "2"
      },
    ],
    // "doan": [
    //   {
    //     "cid": "7",
    //     "image": "assets/images/img7.jpeg",
    //     "title": "선반",
    //     "location": "제주 제주시 아라동",
    //     "price": "15000",
    //     "likes": "2"
    //   },
    //   {
    //     "cid": "8",
    //     "image": "assets/images/img8.jpeg",
    //     "title": "냉장 쇼케이스",
    //     "location": "제주 제주시 아라동",
    //     "price": "80000",
    //     "likes": "3"
    //   },
    //   {
    //     "cid": "9",
    //     "image": "assets/images/img9.jpeg",
    //     "title": "대우 미니냉장고",
    //     "location": "제주 제주시 아라동",
    //     "price": "30000",
    //     "likes": "3"
    //   },
    //   {
    //     "cid": "10",
    //     "image": "assets/images/img10.jpeg",
    //     "title": "멜킨스 풀업 턱걸이 판매합니다.",
    //     "location": "제주 제주시 아라동",
    //     "price": "50000",
    //     "likes": "7"
    //   },
    // ]
  };
  Future<List<Map<String,String>>> loadContentsFromLocation(String location) async{
    //API통신 location값을 보내주면서
    await Future.delayed(Duration(milliseconds: 1000));
    return datas[location];
  }
}