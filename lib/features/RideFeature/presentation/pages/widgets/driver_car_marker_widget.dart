import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverCarMarkerWidget extends StatefulWidget {
  final Function(Marker?) onCarMarkerUpdated;
  final GoogleMapController mapController;

  const DriverCarMarkerWidget({
    super.key,
    required this.onCarMarkerUpdated,
    required this.mapController,
  });

  @override
  State<DriverCarMarkerWidget> createState() => _DriverCarMarkerWidgetState();
}

class _DriverCarMarkerWidgetState extends State<DriverCarMarkerWidget> {
  double _lastAngle = 0;
  BitmapDescriptor? _carIcon;
  Position? _previousPosition;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _loadCarIcon();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
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
    _carIcon = await getResizedCarIcon('assets/images/car_for_tracking.png', width: 150);
  }

  void _startLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      widget.onCarMarkerUpdated(null);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      _updateCarMarker(position);
    });
  }

  void _updateCarMarker(Position position) async{
    double newAngle = _lastAngle;
    final double currentZoom = await widget.mapController.getZoomLevel();
    if (_previousPosition != null) {
      newAngle = _calculateBearing(
        LatLng(_previousPosition!.latitude, _previousPosition!.longitude),
        LatLng(position.latitude, position.longitude),
      );
    }

    final marker = Marker(
      markerId: const MarkerId('car'),
      position: LatLng(position.latitude, position.longitude),
      rotation: newAngle,
      icon: _carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      flat: true,
      anchor: const Offset(0.5, 0.5),
    );

    _lastAngle = newAngle;
    _previousPosition = position;

    widget.mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: currentZoom, // 👈 Adjust this zoom level as needed
          bearing: newAngle, // optional: rotate map to match car direction
        ),
      ),
    );

    widget.onCarMarkerUpdated(marker);
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
