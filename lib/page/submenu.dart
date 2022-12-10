class sandwitch {
  final String name;
  final String content;
  final int price;
  final int saleprice;
  final String image;

  sandwitch({required this.name, required this.content, required this.price, required this.saleprice, required this.image});
}

List<sandwitch> menu= [
  sandwitch(
      name: "베지 샌드위치",
      content: "대표 메뉴",
      price: 4100,
      saleprice: 2870,
      image: "assets/images/베지.png"),
  sandwitch(
      name: "참치 샌드위치",
      content: "대표 메뉴",
      price: 4900,
      saleprice: 3920,
      image: "assets/images/참치.png"),
];