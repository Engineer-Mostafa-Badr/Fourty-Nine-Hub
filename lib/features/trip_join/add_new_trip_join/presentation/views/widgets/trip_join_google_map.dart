import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripJoinGoogleMap extends StatefulWidget {
  const TripJoinGoogleMap({super.key});

  @override
  State<TripJoinGoogleMap> createState() => _TripJoinGoogleMapState();
}

class _TripJoinGoogleMapState extends State<TripJoinGoogleMap> {
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  late StartingLocationCubit startingLocationCubit;
  late DestinationLocationCubit destinationLocationCubit;
  late FetchPriceDistanceCubit fetchPriceDistanceCubit;

  @override
  void initState() {
    startingLocationCubit = context.read<StartingLocationCubit>();
    destinationLocationCubit = context.read<DestinationLocationCubit>();
    fetchPriceDistanceCubit = context.read<FetchPriceDistanceCubit>();
    super.initState();
  }

  static const CameraPosition _egyptLocation = CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 14.4746,
  );

  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StartingLocationCubit, StartingLocationState>(
          listener: (context, state) {
            if (state is StartingLocationSuccess) {
              _fetchPriceAndDistance();
              Future.delayed(const Duration(seconds: 1))
                  .then(
                    (value) => _animateToMarkers(state),
                  )
                  .then((value) => _makeLines());
            }
          },
        ),
        BlocListener<DestinationLocationCubit, DestinationLocationState>(
          listener: (context, state) {
            if (state is DestinationLocationSuccess) {
              _fetchPriceAndDistance();
              Future.delayed(const Duration(seconds: 1))
                  .then(
                    (value) => _animateToMarkers(state),
                  )
                  .then((value) => _makeLines());
            }
          },
        ),
      ],
      child: SizedBox(
        width: double.infinity,
        height: 300.h,
        child: Builder(builder: (context) {
          final startingCubit = context.watch<StartingLocationCubit>();
          final destinationCubit = context.watch<DestinationLocationCubit>();
          markers = _getMarkers(startingCubit, destinationCubit);
          return GoogleMap(
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
            liteModeEnabled: false,
            mapToolbarEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            markers: markers.toSet(),
            polylines: Set<Polyline>.of(polylines.values),
          );
        }),
      ),
    );
  }

  _fetchPriceAndDistance() {
    if (startingLocationCubit.startingLocation != null &&
        destinationLocationCubit.destinationLocation != null) {
      LatLng startLocation = LatLng(
        startingLocationCubit.startingLocation!.coordinates![0]!.toDouble(),
        startingLocationCubit.startingLocation!.coordinates![1]!.toDouble(),
      );
      LatLng destinatonLocation = LatLng(
        destinationLocationCubit.destinationLocation!.coordinates![0]!
            .toDouble(),
        destinationLocationCubit.destinationLocation!.coordinates![1]!
            .toDouble(),
      );
      fetchPriceDistanceCubit.fetchPriceDistance(
        startLocation: startLocation,
        destiantionLocation: destinatonLocation,
      );
    }
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _makeLines() async {
    if (markers.length != 2) {
      return;
    }
    await polylinePoints
        .getRouteBetweenCoordinates(
            googleApiKey: UIConst.googleGeocodingApiKey,
            request: PolylineRequest(
                origin: PointLatLng(
                  markers[0].position.latitude,
                  markers[0].position.longitude,
                ),
                destination: PointLatLng(
                  markers[1].position.latitude,
                  markers[1].position.longitude,
                ),
                mode: TravelMode.driving)
            //Starting LATLANG
            //End LATLANG
            // travelMode: TravelMode.driving,
            )
        .then((value) {
      for (var point in value.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }).then((value) {
      _addPolyLine();
    });
  }

  void _animateToMarkers(var state) {
    double lat = 0;
    double long = 0;
    if (state is StartingLocationSuccess ||
        state is DestinationLocationSuccess) {
      lat = state.locationEntity.coordinates?[0]?.toDouble() ?? 0;
      long = state.locationEntity.coordinates?[1]?.toDouble() ?? 0;
    }

    _animateTo(LatLng(lat, long));
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
