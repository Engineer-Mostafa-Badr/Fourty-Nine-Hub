import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripJoinGoogleMap extends StatefulWidget {
  const TripJoinGoogleMap({super.key});

  @override
  State<TripJoinGoogleMap> createState() => _TripJoinGoogleMapState();
}

class _TripJoinGoogleMapState extends State<TripJoinGoogleMap> {
  late final GoogleMapController _googleMapController;

  static const CameraPosition _egyptLocation = CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _egyptLocation,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
      ),
    );
  }
}
