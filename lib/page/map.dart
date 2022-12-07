import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home/page/menu.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class MapMarker {
  final String? id;
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;

  MapMarker({
    required this.id,
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });
}

final mapMarkers = [
  MapMarker(
    id: '0',
    image: 'assets/images/img2.jpeg',
    title: '써브웨이 대전 건양대점',
    address: '대전 서구 관저동로 170',
    location: LatLng(36.306456, 127.340949),),

  MapMarker(
    id: '1',
      image: 'assets/images/woong.jpg',
      title: '웅이유부',
      address: '대전 서구 관저동로93번길 16-6 1층 101호  (왼쪽 가게)',
      location: LatLng(36.300648, 127.339419),),
  MapMarker(
    id: '2',
    image: 'assets/images/dun.png',
    title: '던킨 도너츠 대전 건양대점',
    address: '대전 서구 관저동로 158 2층(관저동, 본부및도서관동)',
    location: LatLng(51.5382123, -0.1882464),),

  MapMarker(
    id: '3',
      image: 'assets/images/yeoni.jpg',
      title: '연이김밥',
      address: '대전 서구 관저로 23 104호',
      location: LatLng(36.296283, 127.325883),),
];

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  late int selectedIndex = 0;
  //var currentLocation = AppConstants.myLocation;
  late final GoogleMapController mapController;
  //late CameraPosition _current = _kGooglePlex;

  final pageController = PageController();
  //Completer<GoogleMapController> _controller = Completer();

  static late CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _movePage(int selectidIndex) {
    pageController.animateToPage(
        selectedIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut);

  }
  late final List<Marker> _markers = <Marker>[
    // Marker(markerId: MarkerId('1'),
    // position: LatLng(37.42796133580664, -122.085749655962),
    // infoWindow: InfoWindow(title: 'My Position'),
    // ),
    Marker(markerId: MarkerId('0'),
      position: LatLng(36.306456, 127.340949),
      infoWindow: InfoWindow(title: '써브웨이 대전건양대점'),
      onTap: () {
        selectedIndex = 0;
        _movePage(selectedIndex);
      },
    ),
    Marker(markerId: MarkerId('1'),
      position: LatLng(36.300648, 127.339419),
      infoWindow: InfoWindow(title: '웅이유부'),
      onTap: () {
        selectedIndex = 1;
        _movePage(selectedIndex);
      },
    ),
    Marker(markerId: MarkerId('2'),
      position: LatLng(36.305525, 127.343803),
      infoWindow: InfoWindow(title: '던킨도너츠 대전건양대점'),
      onTap: () {
        selectedIndex = 2;
        _movePage(selectedIndex);
      },
    ),
    Marker(markerId: MarkerId('3'),
      position: LatLng(36.296283, 127.325883),
      infoWindow: InfoWindow(title: '연이김밥'),
      onTap: () {
        selectedIndex = 3;
        _movePage(selectedIndex);
      },
    ),

  ];


  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    Position current = await Geolocator.getCurrentPosition();
    _kGooglePlex = CameraPosition(
      target: LatLng(current.latitude, current.longitude),
      zoom: 14.4746,
    );
    //_getCurrentLagLng(current);
    return current;
    //return await Geolocator.getCurrentPosition();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (controller) {
                        getUserCurrentLocation();
                        mapController = controller;
                        //controller.complete(controller);
                      },
                      markers: _markers.toSet(),
                      //Set<Marker>.of(_markers),
                    ),
                  ),
                Positioned(
                  left: 10,
                  bottom: -40,
                  child: SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width -30,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (value) {
                        selectedIndex = value;
                        // currentLocation =
                        // mapMarkers[value].location ??
                        // _animatedMapMove(currentLocation, 11.5);
                        setState(() {
                        });
                      },
                      itemCount: mapMarkers.length,
                      itemBuilder: (_,index) {
                        print(selectedIndex);
                        //index = selectedIndex;
                        final item = mapMarkers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 0),
                          child: GestureDetector(
                            onTap: () => {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            Menu()))
                            },
                            child: Card(

                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),

                          ),
                          color: Colors.green,
                          child: Row(
                            children: [
                              const SizedBox(width:15),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Expanded(
                                      //     child: ListView.builder(
                                      //       padding: EdgeInsets.zero,
                                      //         scrollDirection: Axis.horizontal,
                                      //         //itemCount: item.rating,
                                      //         itemBuilder:
                                      //         (BuildContext context, int index) {
                                      //         },
                                      //     ),
                                      // ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height:5),
                                              Text(
                                                item.title ?? '',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height:3),
                                              Text(
                                                item.address ?? '',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              const SizedBox(width: 0, height: 10,),
                                              SizedBox(
                                                  width: MediaQuery.of(context).size.width-50,
                                                  height: 110,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 1,horizontal:60 ),
                                                    child: ClipRRect(

                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.asset(
                                                        item.image ?? '',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ))
                                    ],
                                  ))
                            ],
                          ),
                        ),),

                        );
                      },
                    ),

                  ),
                ),//),
                )

              ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async{
      //     getUserCurrentLocation().then((value) async {
      //       print(value.latitude.toString() +" "+value.longitude.toString());
      //
      //       // marker added for current users location
      //       // _markers.add(
      //       //     Marker(
      //       //       markerId: MarkerId("2"),
      //       //       position: LatLng(value.latitude, value.longitude),
      //       //       infoWindow: InfoWindow(
      //       //         title: 'My Current Location',
      //       //       ),
      //       //     )
      //       // );
      //       //current_lang = value.latitude;
      //       //current_long = value.longitude;
      //       CameraPosition cameraPosition = new CameraPosition(
      //         target: LatLng(value.latitude, value.longitude),
      //         zoom: 17,
      //       );
      //
      //       final GoogleMapController controller = await _controller.future;
      //       controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      //       setState(() {
      //       });
      //     });
      //   },
      //   child:Icon(Icons.roofing_rounded),
      // ),
      );
  }
}
