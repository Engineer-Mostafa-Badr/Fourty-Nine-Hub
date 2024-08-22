import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FacebookUserOnMap extends StatefulWidget {
  const FacebookUserOnMap({super.key});

  @override
  State<FacebookUserOnMap> createState() => _FacebookUserOnMapState();
}

class _FacebookUserOnMapState extends State<FacebookUserOnMap> {

  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers={};
  
  @override
  void initState() {
    markers.add(const Marker(
      markerId: MarkerId('0'),
      infoWindow: InfoWindow(title: 'user'),
      // icon: markerIcon,
      position: LatLng(31.28180815947351, 31.67713459187959),
    ));
    super.initState();
  }
  


  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: const EdgeInsets.only(top: 100, bottom: 50, left: 25),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      trafficEnabled: false,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: true,
      compassEnabled: true,
      indoorViewEnabled: true,
      buildingsEnabled: true,
      mapToolbarEnabled: true,
      zoomGesturesEnabled: true,
      initialCameraPosition:
          const CameraPosition(
            target: LatLng(31.28180815947351, 31.67713459187959),
            zoom: 12
          ),
      markers: markers,

      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
      mapType: MapType.terrain,
      minMaxZoomPreference: const MinMaxZoomPreference(6,20),
      onCameraMove: (position) {
        print("================> position $position");
        },
      onCameraMoveStarted: () {},
      onCameraIdle: () {
      },
    );
  }
}
