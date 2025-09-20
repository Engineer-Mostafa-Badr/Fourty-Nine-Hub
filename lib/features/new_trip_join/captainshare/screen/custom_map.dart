import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/car_marker_on_client_side_google_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/driver_car_marker_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/car_marker_on_client_side_captain_share.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../res/style/app_colors.dart';

class CustomGoogleMap extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? targetLocation;
  final List<LatLng> clientLocations;
  final List<LatLng> polylinePoints;
  final bool enableScrolling;
  final bool? fromClient;
  final bool? fromCaptainShare;
  final String? startAddress;
  final String? status;
  final String? targetAddress;
  final String? estimatedTime;
  final List<String> clientAddresses;

  const CustomGoogleMap({
    super.key,
    required this.startLocation,
    required this.targetLocation,
    this.clientLocations = const [],
    this.polylinePoints = const [],
    this.enableScrolling = true,
    this.fromCaptainShare,
    this.fromClient,
    this.startAddress,
    this.targetAddress,
    this.status,
    this.estimatedTime,
    this.clientAddresses = const [],
  });

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};
  Marker? _carMarker;

  final LatLngBounds egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 24.7),
    northeast: const LatLng(31.7, 36.0),
  );

  LatLng? _latestStartLocation;

  // Instance-level caching that gets cleared when needed
  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _targetMarkerIcon;
  BitmapDescriptor? _clientMarkerIcon;
  double? _cachedMarkerSize;

  double _currentZoom = 16.0;
  bool _isDisposed = false;
  bool _isUpdatingMarkers = false;

  @override
  void initState() {
    super.initState();
    _latestStartLocation = widget.startLocation;
    _initializeMarkerIcons();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mapController?.dispose();
    // Clear cached icons when disposing
    _startMarkerIcon = null;
    _targetMarkerIcon = null;
    _clientMarkerIcon = null;
    super.dispose();
  }

  // Initialize marker icons - now properly handles updates
  Future<void> _initializeMarkerIcons({bool forceRecreate = false}) async {
    if (_isDisposed || _isUpdatingMarkers) return;

    _isUpdatingMarkers = true;
    final markerSize = _calculateMarkerSizeByZoom(_currentZoom);

    // Recreate icons if forced, don't have them, or size changed significantly
    if (forceRecreate ||
        _startMarkerIcon == null ||
        _cachedMarkerSize == null ||
        (markerSize - _cachedMarkerSize!).abs() > 3) {

      _cachedMarkerSize = markerSize;

      try {
        _startMarkerIcon = await _createSimpleMarker(Colors.green, markerSize);
        _targetMarkerIcon = await _createSimpleMarker(Colors.blue, markerSize);
        _clientMarkerIcon = await _createSimpleMarker(Colors.red, markerSize);
      } catch (e) {
        // Fallback to default markers
        _startMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        _targetMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        _clientMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      }
    }

    _isUpdatingMarkers = false;

    if (!_isDisposed) {
      _setMarkersAndPolyline();
    }
  }

  @override
  void didUpdateWidget(covariant CustomGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isDisposed) return;

    bool shouldUpdate = false;
    bool shouldMoveCameraToFitStartTarget = false;
    bool shouldMoveCameraToFitAll = false;

    // Handle status changes
    if (widget.status != oldWidget.status) {
      if (_mapController != null && widget.startLocation != null &&
          widget.targetLocation != null && widget.status != TripState.started.name) {
        shouldMoveCameraToFitStartTarget = true;
      }
    }

    // Handle start location changes
    if (widget.startLocation != oldWidget.startLocation) {
      _latestStartLocation = widget.startLocation;
      shouldUpdate = true;
      if (_mapController != null && _latestStartLocation != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _latestStartLocation!, zoom: _currentZoom),
          ),
        );
      }
    }

    // Check for significant changes that require full update
    if (_hasSignificantChanges(oldWidget)) {
      shouldUpdate = true;
      shouldMoveCameraToFitAll = true;

      // Clear cached icons when data changes significantly to ensure fresh rendering
      _startMarkerIcon = null;
      _targetMarkerIcon = null;
      _clientMarkerIcon = null;
    }

    if (shouldUpdate) {
      // Reinitialize markers with fresh data
      _initializeMarkerIcons(forceRecreate: true);

      if (shouldMoveCameraToFitStartTarget) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed) _moveCameraToFitStartAndTarget();
        });
      } else if (shouldMoveCameraToFitAll) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isDisposed) {
            _moveCameraToFitAllPoints();
          }
        });
      }
    }
  }

  bool _hasSignificantChanges(CustomGoogleMap oldWidget) {
    return widget.targetLocation != oldWidget.targetLocation ||
        widget.startLocation != oldWidget.startLocation ||
        !_areLatLngListsEqual(widget.polylinePoints, oldWidget.polylinePoints) ||
        !_areLatLngListsEqual(widget.clientLocations, oldWidget.clientLocations) ||
        !_areStringListsEqualUnordered(widget.clientAddresses, oldWidget.clientAddresses) ||
        widget.startAddress != oldWidget.startAddress ||
        widget.targetAddress != oldWidget.targetAddress ||
        widget.fromClient != oldWidget.fromClient ||
        widget.estimatedTime != oldWidget.estimatedTime;
  }

  bool _areLatLngListsEqual(List<LatLng> a, List<LatLng> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].latitude != b[i].latitude || a[i].longitude != b[i].longitude) {
        return false;
      }
    }
    return true;
  }

  bool _areStringListsEqualUnordered(List<String> a, List<String> b) {
    return const SetEquality().equals(a.toSet(), b.toSet());
  }

  void _moveCameraToFitStartAndTarget() {
    if (_mapController == null || widget.startLocation == null ||
        widget.targetLocation == null || _isDisposed) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    double padding = _calculateDynamicPaddingForTop(size.height, size.width);

    final bounds = LatLngBounds(
      southwest: LatLng(
        min(widget.startLocation!.latitude, widget.targetLocation!.latitude),
        min(widget.startLocation!.longitude, widget.targetLocation!.longitude),
      ),
      northeast: LatLng(
        max(widget.startLocation!.latitude, widget.targetLocation!.latitude),
        max(widget.startLocation!.longitude, widget.targetLocation!.longitude),
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  void _moveCameraToFitAllPoints() {
    if (_mapController == null || _isDisposed) return;

    List<LatLng> allPoints = [];
    if (widget.startLocation != null) allPoints.add(widget.startLocation!);
    if (widget.targetLocation != null) allPoints.add(widget.targetLocation!);
    allPoints.addAll(widget.clientLocations);
    allPoints.addAll(widget.polylinePoints);

    if (allPoints.length < 2) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    double minLat = allPoints.first.latitude;
    double maxLat = allPoints.first.latitude;
    double minLng = allPoints.first.longitude;
    double maxLng = allPoints.first.longitude;

    for (var point in allPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    if (bounds.southwest.latitude == bounds.northeast.latitude &&
        bounds.southwest.longitude == bounds.northeast.longitude) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: bounds.southwest, zoom: _currentZoom),
        ),
      );
      return;
    }

    double padding = _calculateDynamicPaddingForTop(size.height, size.width);
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }

  double _calculateDynamicPaddingForTop(double mapHeight, double mapWidth) {
    double smallestDimension = min(mapHeight, mapWidth);
    double paddingPercentage;

    if (smallestDimension < 200) {
      paddingPercentage = 0.18;
    } else if (smallestDimension < 300) {
      paddingPercentage = 0.22;
    } else if (smallestDimension < 500) {
      paddingPercentage = 0.25;
    } else {
      paddingPercentage = 0.28;
    }

    double calculatedPadding = smallestDimension * paddingPercentage;
    return calculatedPadding.clamp(35.0, 150.0);
  }

  double _calculateMarkerSizeByZoom(double zoom) {
    const minZoom = 10.0;
    const maxZoom = 20.0;
    final clampedZoom = zoom.clamp(minZoom, maxZoom);
    final normalized = (clampedZoom - minZoom) / (maxZoom - minZoom);
    return 20 + (normalized * (35 - 20));
  }

  // Highly optimized marker creation using Canvas instead of Widget rendering
  Future<BitmapDescriptor> _createSimpleMarker(Color color, double size) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Outer glow circle
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(size / 2, size / 2),
        size / 2,
        glowPaint,
      );

      // Main marker circle
      final mainPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(size / 2, size / 2),
        (size / 2) * 0.7,
        mainPaint,
      );

      // White border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(
        Offset(size / 2, size / 2),
        (size / 2) * 0.7,
        borderPaint,
      );

      final picture = recorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

      // Proper resource cleanup
      picture.dispose();
      image.dispose();

      return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
    } catch (e) {
      // Fallback to default marker
      return BitmapDescriptor.defaultMarkerWithHue(
          color == Colors.green ? BitmapDescriptor.hueGreen :
          color == Colors.blue ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    if (_isDisposed) return;

    _mapController = controller;
    initMapStyle();
    _setMarkersAndPolyline();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) _moveCameraToFitAllPoints();
    });
  }

  void initMapStyle() async {
    if (_isDisposed || _mapController == null) return;

    try {
      var lightStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/map_styles/light_map_style.json');
      var darkStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/map_styles/dark_map_style.json');

      await _mapController?.setMapStyle(context.isDarkMode ? darkStyle : lightStyle);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) _moveCameraToFitAllPoints();
      });
    } catch (e) {
      print('Error loading map style: $e');
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000;
    double lat1Rad = point1.latitude * pi / 180;
    double lat2Rad = point2.latitude * pi / 180;
    double deltaLatRad = (point2.latitude - point1.latitude) * pi / 180;
    double deltaLngRad = (point2.longitude - point1.longitude) * pi / 180;

    double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
            sin(deltaLngRad / 2) * sin(deltaLngRad / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  List<LatLng> _generateStepPoints(LatLng start, LatLng end, double stepDistance) {
    List<LatLng> stepPoints = [];

    double totalDistance = _calculateDistance(start, end);
    if (totalDistance <= stepDistance) {
      return stepPoints;
    }

    int numberOfSteps = (totalDistance / stepDistance).floor().clamp(0, 15); // Reasonable limit

    for (int i = 1; i <= numberOfSteps; i++) {
      double ratio = (stepDistance * i) / totalDistance;
      double lat = start.latitude + (end.latitude - start.latitude) * ratio;
      double lng = start.longitude + (end.longitude - start.longitude) * ratio;
      stepPoints.add(LatLng(lat, lng));
    }

    return stepPoints;
  }

  void _addStepCircles() {
    if (_isDisposed) return;

    _circles.clear();

    if (widget.polylinePoints.isEmpty) return;

    double circleRadius = _calculateCircleRadiusByZoom(_currentZoom);
    const double stepDistance = 80.0; // Optimized distance
    const int maxCircles = 25; // Reasonable limit

    int circleCount = 0;

    // Add steps between start location and polyline start
    if (widget.startLocation != null && circleCount < maxCircles) {
      LatLng polylineStart = widget.polylinePoints.first;
      List<LatLng> startSteps = _generateStepPoints(
          widget.startLocation!,
          polylineStart,
          stepDistance
      );

      for (int i = 0; i < startSteps.length && circleCount < maxCircles; i++) {
        _circles.add(Circle(
          circleId: CircleId('start_step_$i'),
          center: startSteps[i],
          radius: circleRadius,
          fillColor: Colors.grey.withOpacity(0.25),
          strokeColor: Colors.grey.withOpacity(0.4),
          strokeWidth: 1,
        ));
        circleCount++;
      }
    }

    // Add steps between polyline end and target location
    if (widget.targetLocation != null && circleCount < maxCircles) {
      LatLng polylineEnd = widget.polylinePoints.last;
      List<LatLng> endSteps = _generateStepPoints(
          polylineEnd,
          widget.targetLocation!,
          stepDistance
      );

      for (int i = 0; i < endSteps.length && circleCount < maxCircles; i++) {
        _circles.add(Circle(
          circleId: CircleId('end_step_$i'),
          center: endSteps[i],
          radius: circleRadius,
          fillColor: Colors.grey.withOpacity(0.25),
          strokeColor: Colors.grey.withOpacity(0.4),
          strokeWidth: 1,
        ));
        circleCount++;
      }
    }
  }

  double _calculateCircleRadiusByZoom(double zoom) {
    const minZoom = 10.0;
    const maxZoom = 20.0;
    final clampedZoom = zoom.clamp(minZoom, maxZoom);
    final normalized = (clampedZoom - minZoom) / (maxZoom - minZoom);
    return 3 + (normalized * (8 - 3));
  }

  void _setMarkersAndPolyline() {
    if (_isDisposed || _isUpdatingMarkers) return;

    _markers.clear();
    _polylines.clear();

    // Add start marker
    if (widget.startLocation != null && _startMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: widget.startLocation!,
        icon: _startMarkerIcon!,
        infoWindow: (widget.startAddress?.isNotEmpty ?? false)
            ? InfoWindow(title: widget.startAddress!)
            : const InfoWindow(),
      ));
    }

    // Add target marker
    if (widget.targetLocation != null && _targetMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('target'),
        position: widget.targetLocation!,
        icon: _targetMarkerIcon!,
        infoWindow: (widget.targetAddress?.isNotEmpty ?? false)
            ? InfoWindow(title: widget.targetAddress!)
            : const InfoWindow(),
      ));
    }

    // Add client markers (with reasonable limit)
    final clientLimit = min(widget.clientLocations.length, 20);
    for (int i = 0; i < clientLimit; i++) {
      if (_clientMarkerIcon != null) {
        _markers.add(Marker(
          markerId: MarkerId('client_$i'),
          position: widget.clientLocations[i],
          icon: _clientMarkerIcon!,
          infoWindow: i < widget.clientAddresses.length
              ? InfoWindow(title: widget.clientAddresses[i])
              : const InfoWindow(),
        ));
      }
    }

    // Add polylines with optimized rendering
    if (widget.polylinePoints.isNotEmpty) {
      final clientsCount = widget.clientLocations.length;
      List<Color> gradientColors;
      // if (clientsCount == 0) {
      //   gradientColors = [Colors.green, Colors.blue];
      // } else if (clientsCount == 1) {
      //   gradientColors = [Colors.green, Colors.red, Colors.blue];
      // } else {
      //   gradientColors = [Colors.green, Colors.red, Colors.red, Colors.blue];
      // }
      if(context.isDarkMode){
        gradientColors = [AppColors.PRIMARY_COLOR_DARK, AppColors.blueColor];
      }else{
        gradientColors = [AppColors.PRIMARY_COLOR_DARK, AppColors.PRIMARY_COLOR_DARK];
      }
      _polylines.addAll(_buildOptimizedGradientPolyline(widget.polylinePoints, gradientColors));
    }

    _addStepCircles();

    if (_carMarker != null) {
      _markers.add(_carMarker!);
    }

    if (mounted && !_isDisposed) {
      setState(() {});
    }
  }

  List<Polyline> _buildOptimizedGradientPolyline(List<LatLng> points, List<Color> colors) {
    List<Polyline> gradientPolylines = [];
    if (points.length < 2 || colors.length < 2) return gradientPolylines;

    // Optimize for large point lists
    final maxSegments = 150; // Reasonable limit for performance
    final segmentCount = min(points.length - 1, maxSegments);
    final stepSize = max(1, (points.length - 1) ~/ segmentCount);

    for (int i = 0; i < points.length - stepSize; i += stepSize) {
      final int endIndex = min(i + stepSize, points.length - 1);
      final double t = i / (points.length - 1);
      final double colorIndex = t * (colors.length - 1);
      final int startColorIndex = colorIndex.floor();
      final int endColorIndex = min(colorIndex.ceil(), colors.length - 1);
      final double localT = colorIndex - startColorIndex;

      final Color interpolatedColor = Color.lerp(
        colors[startColorIndex],
        colors[endColorIndex],
        localT,
      )!;

      gradientPolylines.add(
        Polyline(
          polylineId: PolylineId('gradient_$i'),
          points: [points[i], points[endIndex]],
          color: interpolatedColor,
          width: 4,
        ),
      );
    }

    return gradientPolylines;
  }

  void _updateCarMarker(Marker? marker) {
    if (_isDisposed) return;

    setState(() {
      _carMarker = marker;
    });
    _setMarkersAndPolyline();
  }

  void removeCarMarker() {
    if (_isDisposed) return;

    setState(() {
      _carMarker = null;
    });
    _setMarkersAndPolyline();
  }

  LatLng _getInitialCenter() {
    return widget.startLocation ??
        widget.targetLocation ??
        const LatLng(30.033333, 31.233334);
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
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح Google Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    Widget mapWidget = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
          target: _getInitialCenter(),
          zoom: _currentZoom
      ),
      markers: _markers,
      polylines: _polylines,
      circles: _circles,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: widget.enableScrolling,
      zoomGesturesEnabled: widget.enableScrolling,
      tiltGesturesEnabled: widget.enableScrolling,
      rotateGesturesEnabled: widget.enableScrolling,
      cameraTargetBounds: CameraTargetBounds(egyptBounds),
      onCameraMove: (CameraPosition position) {
        if (_isDisposed || _isUpdatingMarkers) return;

        // Only update when zoom changes significantly
        if ((_currentZoom - position.zoom).abs() >= 1.5) {
          _currentZoom = position.zoom;

          // Debounced update to prevent excessive calls
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!_isDisposed && mounted && !_isUpdatingMarkers) {
              _initializeMarkerIcons();
            }
          });
        }
      },
    );

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: widget.enableScrolling ? mapWidget : IgnorePointer(child: mapWidget),
        ),
        if (widget.fromClient == true && _mapController != null && !_isDisposed)
          GoogleMapCarMarkerWidget(
            onCarMarkerUpdated: _updateCarMarker,
            mapController: _mapController!,
            size: _currentZoom,
          ),
        if (widget.fromClient == false && _mapController != null && !_isDisposed)
          DriverCarMarkerWidget(
            onCarMarkerUpdated: _updateCarMarker,
            mapController: _mapController!,
            size: _currentZoom,
            time: widget.estimatedTime,
          ),
        if (widget.fromCaptainShare == true && _mapController != null && !_isDisposed)
          CarMarkerOnClientSideCaptainShare(
            onCarMarkerUpdated: _updateCarMarker,
            mapController: _mapController!,
            size: _currentZoom,
            // time: widget.estimatedTime,
          )
      ],
    );
  }
}