import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

final mapMarkers = [
  MapMarker(
      image: 'assets/images/dun.png',
      title: '던킨 도너츠 대전 건양대점',
      address: '대전 서구 관저동로 158 2층(관저동, 본부및도서관동)',
      location: LatLng(51.5382123, -0.1882464),
      rating: 4),
  MapMarker(
      image: 'assets/images/img2.jpeg',
      title: 'Mestizo Mexican Restaurant',
      address: '103 Hampstead Rd, London NW1 3EL, United Kingdom',
      location: LatLng(51.5090229, -0.2886548),
      rating: 5),
  MapMarker(
      image: 'assets/images/img3.jpeg',
      title: 'The Shed',
      address: '122 Palace Gardens Terrace, London W8 4RT, United Kingdom',
      location: LatLng(51.5090215, -0.1959988),
      rating: 2),
  MapMarker(
      image: 'assets/images/img4.jpeg',
      title: 'Gaucho Tower Bridge',
      address: '2 More London Riverside, London SE1 2AP, United Kingdom',
      location: LatLng(51.5054563, -0.0798412),
      rating: 3),
];

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  int selectedIndex = 0;
  //var currentLocation = AppConstants.myLocation;
  GoogleMapController? mapController;


  final pageController = PageController();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[
    // Marker(markerId: MarkerId('1'),
    // position: LatLng(37.42796133580664, -122.085749655962),
    // infoWindow: InfoWindow(title: 'My Position'),
    // ),
    Marker(markerId: MarkerId('3'),
      position: LatLng(36.306456, 127.340949),
      infoWindow: InfoWindow(title: '써브웨이 대전건양대점'),
    ),
    Marker(markerId: MarkerId('5'),
      position: LatLng(36.300648, 127.339419),
      infoWindow: InfoWindow(title: '웅이유부'),
    ),
    Marker(markerId: MarkerId('7'),
      position: LatLng(36.305525, 127.343803),
      infoWindow: InfoWindow(title: '던킨도너츠 대전건양대점'),
    ),
    Marker(markerId: MarkerId('10'),
      position: LatLng(36.296283, 127.325883),
      infoWindow: InfoWindow(title: '연이김밥'),
    ),

  ];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: _appbarWidget(),
    //   body:
    //   _bodyWidget(),
    //   floatingActionButton: FloatingActionButton(
    //       backgroundColor: Colors.green,
    //       child: Icon(Icons.add),
    //       onPressed: () {
    //         Navigator.push(context, MaterialPageRoute(builder: (context) =>
    //             post()));
    //       },
    //
    return Scaffold(
          body: Column(
              children: [
                Expanded(
                  child:
                GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers.toSet(),
                  //Set<Marker>.of(_markers),
                ),
                ),
                Expanded(
                    child: SizedBox(
                      height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child:                   PageView.builder(
                      controller: pageController,
                      onPageChanged: (value) {
                        selectedIndex = value;
                        //currentLocation =
                        //mapMarkers[value].location ??
                        //_animatedMapMove(currentLocation, 11.5);
                        setState(() {
                        });
                      },
                      itemCount: mapMarkers.length,
                      itemBuilder: (_,index) {
                        final item = mapMarkers[index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                            ),
                            color: Colors.green,
                            child: Row(
                              children: [
                                const SizedBox(width:10),
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
                                                const SizedBox(height:3),
                                                Text(
                                                  item.title ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height:5),
                                                Text(
                                                  item.address ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white60,
                                                  ),
                                                ),
                                                const SizedBox(width: 1, height: 3,),
                                                Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4.0),
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
                          ),);
                      },
                    ),

                  ),
                )),
              ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() +" "+value.longitude.toString());

            // marker added for current users location
            _markers.add(
                Marker(
                  markerId: MarkerId("2"),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(
                    title: 'My Current Location',
                  ),
                )
            );
            CameraPosition cameraPosition = new CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 17,
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
            });
          });
        },
        child:Icon(Icons.roofing_rounded),
      ),
      );
  }
}
