import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripJoinGoogleMap extends StatefulWidget {
  const TripJoinGoogleMap({super.key});

  @override
  State<TripJoinGoogleMap> createState() => _TripJoinGoogleMapState();
}

class _TripJoinGoogleMapState extends State<TripJoinGoogleMap> {
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  static const CameraPosition _egyptLocation = CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 14.4746,
  );
  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    final startingCubit = context.watch<StartingLocationCubit>();
    final destinationCubit = context.watch<DestinationLocationCubit>();
    markers = _getMarkers(startingCubit, destinationCubit);
    _animateToMarkers();
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: markers.isEmpty
            ? _egyptLocation
            : CameraPosition(target: markers[0].position),
        onMapCreated: (GoogleMapController controller) {
          _googleMapController.complete(controller);
        },
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers.toSet(),
      ),
    );
  }

  void _animateToMarkers() {
    if (markers.length == 2) {
      _animateTo(markers[1].position);
    }
    if (markers.isNotEmpty) {
      _animateTo(markers[0].position);
    }
  }

  Future<void> _animateTo(LatLng latLng) async {
    final GoogleMapController c = await _googleMapController.future;
    final p = CameraPosition(target: latLng, zoom: 12.8);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  List<Marker> _getMarkers(
    StartingLocationCubit startingCubit,
    DestinationLocationCubit destinationCubit,
  ) {
    List<Marker> result = [];
    if (startingCubit.startingLocation != null) {
      result.add(
        Marker(
          markerId: const MarkerId('startingMarker'),
          position: LatLng(
            startingCubit.startingLocation!.coordinates?[0]?.toDouble() ?? 0,
            startingCubit.startingLocation!.coordinates?[1]?.toDouble() ?? 0,
          ),
        ),
      );
    }
    if (destinationCubit.destinationLocation != null) {
      result.add(
        Marker(
          markerId: const MarkerId('destinatonMarker'),
          position: LatLng(
            destinationCubit.destinationLocation!.coordinates?[0]?.toDouble() ??
                0,
            destinationCubit.destinationLocation!.coordinates?[1]?.toDouble() ??
                0,
          ),
        ),
      );
    }
    return result;
  }
}
