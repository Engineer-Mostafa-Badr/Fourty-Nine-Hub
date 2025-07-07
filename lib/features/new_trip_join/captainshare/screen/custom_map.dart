import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  final LatLng startLocation;
  final LatLng targetLocation;
  final List<LatLng> clientLocations;
  final List<LatLng> polylinePoints;

  const CustomGoogleMap({
    super.key,
    required this.startLocation,
    required this.targetLocation,
    this.clientLocations = const [],
    this.polylinePoints = const [],
  });

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late GoogleMapController _mapController;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _setMarkersAndPolyline();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _setMarkersAndPolyline() {
    _markers.clear();
    _polylines.clear();

    // Start Marker
    if (widget.startLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: widget.startLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    // Target Marker
    if (widget.targetLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('target'),
          position: widget.targetLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Client Markers
    for (int i = 0; i < widget.clientLocations.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('client_$i'),
          position: widget.clientLocations[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Polyline
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _getInitialCenter(),
          zoom: 12.0,
        ),
        markers: _markers,
        polylines: _polylines,
        mapType: Theme.of(context).brightness == Brightness.dark
            ? MapType.hybrid
            : MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
