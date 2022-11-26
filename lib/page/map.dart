import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';


class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[
    Marker(markerId: MarkerId('1'),
    position: LatLng(37.42796133580664, -122.085749655962),
    infoWindow: InfoWindow(title: 'My Position'))
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
    return Container(
          child: Column(
              children: [
                Expanded(child:
                GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(_markers),
                ),
                ),
    FloatingActionButton(
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
      zoom: 14,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
    });
    });
    },
      child:Icon(Icons.roofing_rounded),
    ),

    ])
      );
  }
}
