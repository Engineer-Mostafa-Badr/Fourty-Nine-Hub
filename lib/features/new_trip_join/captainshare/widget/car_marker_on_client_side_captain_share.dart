import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CarMarkerOnClientSideCaptainShare extends StatefulWidget {
  final Function(Marker?) onCarMarkerUpdated;
  final GoogleMapController mapController;
  final double size;

  const CarMarkerOnClientSideCaptainShare({
    super.key,
    required this.onCarMarkerUpdated,
    required this.mapController,
    this.size = 8,
  });

  @override
  State<CarMarkerOnClientSideCaptainShare> createState() => _CarMarkerOnClientSideCaptainShareState();
}

class _CarMarkerOnClientSideCaptainShareState extends State<CarMarkerOnClientSideCaptainShare> {
  double _lastAngle = 0;
  BitmapDescriptor? _carIcon;
  StreamSubscription? _rideSub;

  @override
  void initState() {
    super.initState();
    _loadCarIcon();
    _subscribeToRideCubit();
  }

  @override
  void dispose() {
    _rideSub?.cancel();
    super.dispose();
  }

  Future<BitmapDescriptor> getResizedCarIcon(String assetPath, {int width = 64}) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }

  Future<void> _loadCarIcon() async {
    if (_carIcon != null) return;

    _carIcon = await getResizedCarIcon(
      'assets/images/car_for_tracking.png',
      width: (widget.size * 8).toInt(),
    );
  }

  Future<void> _subscribeToRideCubit() async {
      final currentLocation = context.read<CaptainShareCubit>().state.driverLocation;
      final previousLocation = context.read<CaptainShareCubit>().state.previousDriverLocation;
      final double currentZoom = await widget.mapController.getZoomLevel();

      if(currentLocation != null){
      double newAngle = _lastAngle;

      if (previousLocation != null) {
        newAngle = _calculateBearing(previousLocation, currentLocation);
      }

      // final String? eta = DateFormat('h:mm a').format(DateTime.parse(trip?.driverIsArrivingIn.toString()??''));

      final marker = Marker(
        markerId: const MarkerId('car'),
        position: currentLocation,
        rotation: newAngle,
        icon: _carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        flat: true,
        anchor: const Offset(0.5, 0.5),
        // infoWindow: (eta != null && eta.isNotEmpty) ? InfoWindow(title: "ETA: $eta") : const InfoWindow(),
        onTap: () {
          ManageVibration.vibrate();
          // if (eta != null && eta.isNotEmpty) {
          //   widget.mapController.showMarkerInfoWindow(const MarkerId("car"));
          // }
        },
      );

      _lastAngle = newAngle;

      widget.mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation,
            zoom: currentZoom,
            bearing: newAngle,
          ),
        ),
      );

      widget.onCarMarkerUpdated(marker);

      // if (eta != null && eta.isNotEmpty) {
      //   Future.delayed(const Duration(milliseconds: 300), () {
      //     widget.mapController.showMarkerInfoWindow(const MarkerId("car"));
      //   });
      // }
    }
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * (pi / 180);
    final double lat2 = to.latitude * (pi / 180);
    final double deltaLng = (to.longitude - from.longitude) * (pi / 180);

    final double y = sin(deltaLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);
    final double bearing = atan2(y, x);

    return (bearing * (180 / pi) + 360) % 360;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}