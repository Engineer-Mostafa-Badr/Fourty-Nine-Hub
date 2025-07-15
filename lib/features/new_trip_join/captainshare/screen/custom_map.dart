import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? targetLocation;
  final List<LatLng> clientLocations;
  final List<LatLng> polylinePoints;
  final bool enableScrolling;
  final bool showCarMarker;
  final LatLng? carLocation;
  final double? carAngle;

  const CustomGoogleMap({
    super.key,
    required this.startLocation,
    required this.targetLocation,
    this.clientLocations = const [],
    this.polylinePoints = const [],
    this.enableScrolling = true,
    this.showCarMarker = false,
    this.carLocation,
    this.carAngle,
  });

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _mapController = Completer();
  bool _isMapReady = false;
  String? _currentMapStyle;
  BitmapDescriptor? _carIcon;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  final LatLngBounds _egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 24.7),
    northeast: const LatLng(31.7, 36.0),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if(widget.showCarMarker)_loadCarIcon();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isMapReady && Platform.isAndroid) {
      _forceMapRerender();
    }
  }

  Future<void> _loadCarIcon() async {
    _carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(8, 8)),
      'assets/images/car_for_tracking.png',
    );
  }

  Future<void> _forceMapRerender() async {
    if (!_isMapReady) return;
    try {
      final controller = await _mapController.future;
      await controller.setMapStyle(null);
      await Future.delayed(const Duration(milliseconds: 100));
      if (_currentMapStyle != null) {
        await controller.setMapStyle(_currentMapStyle);
      }
    } catch (e) {
      log('Error forcing map re-render: $e');
    }
  }

  @override
  void didUpdateWidget(CustomGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldUpdateMarkers(oldWidget) || _shouldUpdatePolyline(oldWidget)) {
      _updateMapData();
    }
  }

  bool _shouldUpdateMarkers(CustomGoogleMap oldWidget) {
    return oldWidget.startLocation != widget.startLocation ||
        oldWidget.targetLocation != widget.targetLocation ||
        oldWidget.clientLocations != widget.clientLocations ||
        oldWidget.carLocation != widget.carLocation ||
        oldWidget.carAngle != widget.carAngle;
  }

  bool _shouldUpdatePolyline(CustomGoogleMap oldWidget) {
    return oldWidget.polylinePoints != widget.polylinePoints;
  }

  Future<void> _updateMapData() async {
    if (!_isMapReady) return;

    _markers.clear();
    _polylines.clear();

    // Add start location marker
    if (widget.startLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: widget.startLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    // Add target location marker
    if (widget.targetLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('target'),
          position: widget.targetLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add client locations markers
    for (int i = 0; i < widget.clientLocations.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('client_$i'),
          position: widget.clientLocations[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Add car marker if available
    if (widget.carLocation != null && _carIcon != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('car'),
          position: widget.carLocation!,
          icon: _carIcon!,
          rotation: widget.carAngle ?? 0.0,
          flat: true,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    // Add polyline if points exist
    if (widget.polylinePoints.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: widget.polylinePoints,
          color: Colors.black87,
          width: 4,
        ),
      );
    }

    if (mounted) setState(() {});
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    _isMapReady = true;
    await _updateMapData();
    await _initMapStyle();

    // Move camera to start location if available
    if (widget.startLocation != null) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.startLocation!,
            zoom: 12.0,
          ),
        ),
      );
    }
  }

  Future<void> _initMapStyle() async {
    try {
      final lightStyle = await rootBundle.loadString('assets/map_styles/light_map_style.json');
      final darkStyle = await rootBundle.loadString('assets/map_styles/dark_map_style.json');
      _currentMapStyle = context.isDarkMode ? darkStyle : lightStyle;
      final controller = await _mapController.future;
      await controller.setMapStyle(_currentMapStyle);
    } catch (e) {
      log('Error loading map style: $e');
    }
  }

  LatLng _getInitialCameraPosition() {
    return widget.startLocation ?? widget.targetLocation ?? const LatLng(30.033333, 31.233334);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: GoogleMap(
        key: ValueKey('google_map_${widget.hashCode}'),
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _getInitialCameraPosition(),
          zoom: 12.0,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        scrollGesturesEnabled: widget.enableScrolling,
        zoomGesturesEnabled: widget.enableScrolling,
        tiltGesturesEnabled: widget.enableScrolling,
        rotateGesturesEnabled: widget.enableScrolling,
        cameraTargetBounds: CameraTargetBounds(_egyptBounds),
        compassEnabled: false,
        mapType: MapType.normal,
        buildingsEnabled: false,
        indoorViewEnabled: false,
        trafficEnabled: false,
        liteModeEnabled: false,
      ),
    );
  }
}