import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class CustomGoogleMap extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? targetLocation;
  final List<LatLng> clientLocations;
  final List<LatLng> polylinePoints;
  final bool enableScrolling;

  const CustomGoogleMap({
    super.key,
    required this.startLocation,
    required this.targetLocation,
    this.clientLocations = const [],
    this.polylinePoints = const [],
    this.enableScrolling = true,
  });

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> with WidgetsBindingObserver {
  late GoogleMapController _mapController;
  bool _isMapReady = false;
  String? _currentMapStyle;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("object widget.startLocation != null ${widget.startLocation}");
    print("object widget.targetLocation != null ${widget.targetLocation}");
    _setMarkersAndPolyline();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Force re-render when app comes back to foreground (Android fix)
    if (state == AppLifecycleState.resumed && _isMapReady && Platform.isAndroid) {
      _forceMapRerender();
    }
  }

  final LatLngBounds egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 24.7),
    northeast: const LatLng(31.7, 36.0),
  );

  Future<void> _forceMapRerender() async {
    if (!_isMapReady) return;

    try {
      // Force a map style re-render to fix Android rendering issues
      await _mapController.setMapStyle(null);
      await Future.delayed(const Duration(milliseconds: 100));
      if (_currentMapStyle != null) {
        await _mapController.setMapStyle(_currentMapStyle);
      }
    } catch (e) {
      print('Error forcing map re-render: $e');
    }
  }

  Future<void> initMapStyle() async {
    try {
      var lightStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/light_map_style.json');
      var darkStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');

      _currentMapStyle = context.isDarkMode ? darkStyle : lightStyle;

      if (_isMapReady) {
        await _mapController.setMapStyle(_currentMapStyle);
      }
    } catch (e) {
      print('Error loading map style: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    // Add delay to ensure map is fully initialized
    await Future.delayed(const Duration(milliseconds: 300));

    _isMapReady = true;

    // Initialize map style with additional delay
    await Future.delayed(const Duration(milliseconds: 200));


    _setMarkersAndPolyline();

    // Move camera only if startLocation is not null
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.startLocation != null) {
        print("object widget.startLocation != null ${widget.startLocation}");
        try {
          // Add delay before camera movement
          await Future.delayed(const Duration(milliseconds: 500));
          await _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: widget.startLocation!,
                zoom: 12.0,
              ),
            ),
          );
        } catch (e) {
          print('Error moving camera: $e');
        }
      }
    });
    await initMapStyle();
  }



  void _setMarkersAndPolyline() {
    _markers.clear();
    _polylines.clear();

    if (widget.startLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: widget.startLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (widget.targetLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('target'),
          position: widget.targetLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    for (int i = 0; i < widget.clientLocations.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('client_$i'),
          position: widget.clientLocations[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

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
  }

  LatLng _getInitialCenter() {
    return widget.startLocation ??
        widget.targetLocation ??
        const LatLng(30.033333, 31.233334); // Default to Cairo
  }

  Future<void> _openDirections() async {
    if (widget.startLocation != null && widget.targetLocation != null) {
      final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
            '&origin=${widget.startLocation!.latitude},${widget.startLocation!.longitude}'
            '&destination=${widget.targetLocation!.latitude},${widget.targetLocation!.longitude}'
            '&travelmode=driving',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح Google Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("object widget.startLocation != null ${widget.startLocation}");
    print("object widget.targetLocation != null ${widget.targetLocation}");

    Widget mapWidget = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _getInitialCenter(),
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
      cameraTargetBounds: CameraTargetBounds(egyptBounds),
      // Add these for better Android performance
      compassEnabled: false,
      mapType: MapType.normal,
      buildingsEnabled: false,
      indoorViewEnabled: false,
      trafficEnabled: false,
      // Force hardware acceleration - CRITICAL for Android
      liteModeEnabled: false,
      // // Add this to prevent rendering issues
      // gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(
      //       () => PanGestureRecognizer(),
      // )),
    );

    // Wrap map in Container with specific constraints to fix rendering
    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: widget.enableScrolling ? mapWidget : IgnorePointer(child: mapWidget),
    );
  }
}