import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewDetails extends StatelessWidget {
  const MapViewDetails({super.key, this.startLocation, this.targetLocation, required this.clientLocations, required this.polylinePoints});
  final LatLng? startLocation;
  final LatLng? targetLocation;
  final List<LatLng> clientLocations;
  final List<LatLng> polylinePoints;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomGoogleMap(
        startLocation: startLocation,
        targetLocation: targetLocation,
        polylinePoints:polylinePoints,
        clientLocations: clientLocations,
      ),
    );
  }
}
