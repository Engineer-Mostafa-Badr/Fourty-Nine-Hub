import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DriverCarMarkerWidget extends StatefulWidget {
  final Function(Marker?) onCarMarkerUpdated;
  final GoogleMapController mapController;
  final double size;
  final String? time;

  const DriverCarMarkerWidget({
    super.key,
    required this.onCarMarkerUpdated,
    required this.size,
    required this.mapController,
    this.time,
  });

  @override
  State<DriverCarMarkerWidget> createState() => DriverCarMarkerWidgetState();
}

class DriverCarMarkerWidgetState extends State<DriverCarMarkerWidget> {
  double _lastAngle = 0;
  BitmapDescriptor? _carIcon;
  Position? _previousPosition;
  StreamSubscription<Position>? _positionStream;
  String? _time;

  @override
  void initState() {
    super.initState();
    _time = widget.time;
    if (widget.time != null && widget.time!.isNotEmpty) {
      widget.mapController.showMarkerInfoWindow(const MarkerId("car"));
    }
    _loadCarIcon();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DriverCarMarkerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.time != oldWidget.time) {
      updateTime(widget.time);
    }
  }

  void updateTime(String? newTime) {
    print("updateTime time $newTime");
    if (newTime != _time) {
      _time = newTime;

      if (_previousPosition != null) {
        _updateCarMarker(_previousPosition!);
      }

      // Wait for the marker to be fully updated on the map
      Future.delayed(Duration(milliseconds: 300), () {
        if (_time != null && _time!.isNotEmpty) {
          widget.mapController.showMarkerInfoWindow(const MarkerId("car"));
        } else {
          widget.mapController.hideMarkerInfoWindow(const MarkerId("car"));
        }
      });
    }
  }

  Future<BitmapDescriptor> getResizedCarIcon(String assetPath, {int width = 128}) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }

  Future<void> _loadCarIcon() async {
    if (_carIcon != null) return;
    _carIcon = await getResizedCarIcon('assets/images/car_for_tracking.png', width: (widget.size * 8).toInt());
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

  void _updateCarMarker(Position position) async {
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
        infoWindow: (_time != null && _time!.isNotEmpty)
            ? InfoWindow(title: "ETA $_time")
            : const InfoWindow(),
        onTap: () {
      ManageVibration.vibrate();
          print("onTap");
          if (_time != null && _time!.isNotEmpty) {
            widget.mapController.showMarkerInfoWindow(const MarkerId("car"));
          }
        }
    );

    _lastAngle = newAngle;
    _previousPosition = position;

    widget.mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: currentZoom,
          bearing: newAngle,
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
    final double x =
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);
    final double bearing = atan2(y, x);

    return (bearing * (180 / pi) + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    print("widget.time1: ${widget.time}");
    return const SizedBox.shrink();
  }
}