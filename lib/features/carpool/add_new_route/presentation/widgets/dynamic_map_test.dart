import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../../../../core/widget/custom_scaffold.dart';

class DynamicMapWithPolyline extends StatefulWidget {
  final String apiKey;
  final String url;
  final bool useGoogleMaps;
  final bool showNavBar;
  final double? latitude;
  final double? longitude;
  final List<LatLng>? polylineString;

  const DynamicMapWithPolyline({
    super.key,
    required this.apiKey,
    required this.url,
    this.showNavBar = true,
    this.useGoogleMaps = false,
    this.latitude,
    this.longitude,
    this.polylineString,
  });

  @override
  _DynamicMapWithPolyline createState() => _DynamicMapWithPolyline();
}

class _DynamicMapWithPolyline extends State<DynamicMapWithPolyline> {
  late gmaps.GoogleMapController _googleMapController;
  late MapController _mapController;
  double _currentZoom = 12.0;
  late LatLng _center;
  bool _isGoogleMapInitialized = false;
  bool _isFlutterMapInitialized = false;

  @override
  void initState() {
    super.initState();
    print("polyLine ${widget.polylineString} \n");

    if (widget.latitude == null && widget.longitude == null) {
      _center = const LatLng(30.0444, 31.2357); // Default to Cairo
    } else {
      _center = LatLng(widget.latitude ?? 30.0444, widget.longitude ?? 31.2357);
    }

    _mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.latitude != null && widget.longitude != null) {
        updateCenter(LatLng(widget.latitude!, widget.longitude!));
      }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    if (_isGoogleMapInitialized) {
      _googleMapController.dispose();
    }
    super.dispose();
  }

  List<LatLng> decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int result = 0;
      int shift = 0;
      int b;
      do {
        if (index >= polyline.length) break;
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      result = 0;
      shift = 0;

      do {
        if (index >= polyline.length) break;
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat * 1e-5, lng * 1e-5));
    }

    return points;
  }

  void updateCenter(LatLng newCenter) {
    if (_isFlutterMapInitialized) {
      setState(() {
        _center = newCenter;
      });
      _mapController.move(newCenter, _currentZoom);
    } else {
      _center = newCenter;
    }
  }

  void _onGoogleMapCreated(gmaps.GoogleMapController controller) {
    _googleMapController = controller;
    _isGoogleMapInitialized = true;
    if (widget.latitude != null && widget.longitude != null) {
      _googleMapController.animateCamera(
        gmaps.CameraUpdate.newLatLng(
          gmaps.LatLng(widget.latitude!, widget.longitude!),
        ),
      );
    }
    _centerPolylineOnGoogleMap();
  }

  void _centerPolylineOnGoogleMap() {
    if (widget.polylineString != null) {
      List<LatLng> polylinePoints = widget.polylineString!;
      if (polylinePoints.isNotEmpty) {
        final bounds = gmaps.LatLngBounds(
          southwest: gmaps.LatLng(
            polylinePoints
                .map((p) => p.latitude)
                .reduce((a, b) => a < b ? a : b),
            polylinePoints
                .map((p) => p.longitude)
                .reduce((a, b) => a < b ? a : b),
          ),
          northeast: gmaps.LatLng(
            polylinePoints
                .map((p) => p.latitude)
                .reduce((a, b) => a > b ? a : b),
            polylinePoints
                .map((p) => p.longitude)
                .reduce((a, b) => a > b ? a : b),
          ),
        );

        _googleMapController
            .animateCamera(gmaps.CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
  }

  void _centerPolylineOnFlutterMap() {
    if (widget.polylineString != null) {
      List<LatLng> polylinePoints = widget.polylineString!;
      if (polylinePoints.isNotEmpty) {
        double minLat = polylinePoints
            .map((p) => p.latitude)
            .reduce((a, b) => a < b ? a : b);
        double maxLat = polylinePoints
            .map((p) => p.latitude)
            .reduce((a, b) => a > b ? a : b);
        double minLng = polylinePoints
            .map((p) => p.longitude)
            .reduce((a, b) => a < b ? a : b);
        double maxLng = polylinePoints
            .map((p) => p.longitude)
            .reduce((a, b) => a > b ? a : b);

        LatLng center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

        if (_isFlutterMapInitialized) {
          setState(() {
            _center = center;
            _currentZoom = 12.0;
          });
          _mapController.move(_center, _currentZoom);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> polylinePoints = widget.polylineString != null
        ? widget.polylineString!
        : [];

    return CustomScaffold(
      showNavBAr: widget.showNavBar,
      body: Stack(
        children: [
          widget.useGoogleMaps
              ? gmaps.GoogleMap(
                  onMapCreated: _onGoogleMapCreated,
                  initialCameraPosition: gmaps.CameraPosition(
                    target: gmaps.LatLng(
                      widget.latitude ?? _center.latitude,
                      widget.longitude ?? _center.longitude,
                    ),
                    zoom: _currentZoom,
                  ),
                  markers: widget.latitude != null && widget.longitude != null
                      ? {
                          gmaps.Marker(
                            markerId: const gmaps.MarkerId("pin"),
                            position: gmaps.LatLng(
                              widget.latitude!,
                              widget.longitude!,
                            ),
                          ),
                        }
                      : {},
                  polylines: widget.polylineString != null
                      ? {
                          gmaps.Polyline(
                            polylineId: const gmaps.PolylineId("route"),
                            points: polylinePoints
                                .map((point) => gmaps.LatLng(
                                    point.latitude, point.longitude))
                                .toList(),
                            color: AppColors.SECONDARY_COLOR,
                            width: 4,
                          ),
                        }
                      : {},
                )
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: _currentZoom,
                    onMapReady: () {
                      setState(() {
                        _isFlutterMapInitialized = true;
                      });
                      _centerPolylineOnFlutterMap();
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: widget.url,
                    ),
                    if (widget.latitude != null && widget.longitude != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(widget.latitude!, widget.longitude!),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    if (widget.polylineString != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: polylinePoints,
                            strokeWidth: 4.0,
                            color: AppColors.SECONDARY_COLOR,
                          ),
                        ],
                      ),
                  ],
                ),
          if (!widget.useGoogleMaps)
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentZoom++;
                        _mapController.move(_center, _currentZoom);
                      });
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.BACKGROUND_COLOR,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentZoom--;
                        _mapController.move(_center, _currentZoom);
                      });
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.BACKGROUND_COLOR,
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
