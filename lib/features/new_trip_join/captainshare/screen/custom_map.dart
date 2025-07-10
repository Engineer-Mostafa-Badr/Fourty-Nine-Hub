import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomGoogleMap extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? targetLocation;
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
    print("object widget.startLocation != null ${widget.startLocation}");
    print("object widget.targetLocation != null ${widget.targetLocation}");

    _setMarkersAndPolyline();
  }

  final LatLngBounds egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 24.7),   // أسوان/الحدود الجنوبية الغربية
    northeast: const LatLng(31.7, 36.0),   // الإسكندرية/الحدود الشمالية الشرقية
  );

  Future<void> initMapStyle() async {
    var lightStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/light_map_style.json');
    var darkStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');
    _mapController.setMapStyle(context.isDarkMode ? darkStyle : lightStyle);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    initMapStyle();
    _setMarkersAndPolyline();

    // Move camera only if startLocation is not null
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.startLocation != null) {
        print("object widget.startLocation != null ${widget.startLocation}");
        _mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: widget.startLocation!,
              zoom: 12.0,
            ),
          ),
        );
      }
    });
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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          GoogleMap(
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
            scrollGesturesEnabled: true,
            cameraTargetBounds: CameraTargetBounds(egyptBounds),
          ),


        ],
      ),
    );
  }
}
