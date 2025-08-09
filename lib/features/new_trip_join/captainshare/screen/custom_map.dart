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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomGoogleMap extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? targetLocation;
  final List<LatLng> clientLocations;
  final List<LatLng> polylinePoints;
  final bool enableScrolling;
  final bool? fromClient;
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
  final Set<Circle> _circles = {}; // إضافة الدوائر
  Marker? _carMarker;

  final LatLngBounds egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 24.7),
    northeast: const LatLng(31.7, 36.0),
  );

  LatLng? _latestStartLocation;
  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _targetMarkerIcon;
  BitmapDescriptor? _clientMarkerIcon;
  double _currentZoom = 16.0;

  @override
  void initState() {
    super.initState();
    _latestStartLocation = widget.startLocation;
    _createCustomMarkerIcons(_calculateMarkerSizeByZoom(_currentZoom));
  }

  @override
  void didUpdateWidget(covariant CustomGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool shouldUpdate = false;

    if (widget.status != oldWidget.status) {
      if (_mapController != null && widget.startLocation != null && widget.targetLocation != null && widget.status != TripState.started.name) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _moveCameraToFitStartAndTarget();
        });
      }
    }

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
    bool areLatLngListsEqual(List<LatLng> a, List<LatLng> b) {
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (a[i].latitude != b[i].latitude || a[i].longitude != b[i].longitude) {
          return false;
        }
      }
      return true;
    }

    bool areStringListsEqualUnordered(List<String> a, List<String> b) {
      return const SetEquality().equals(a.toSet(), b.toSet());
    }

    if (widget.targetLocation != oldWidget.targetLocation ||
        widget.startLocation != oldWidget.startLocation ||
        !areLatLngListsEqual(widget.polylinePoints, oldWidget.polylinePoints) ||
        !areLatLngListsEqual(widget.clientLocations, oldWidget.clientLocations) ||
        !areStringListsEqualUnordered(widget.clientAddresses, oldWidget.clientAddresses) ||
        widget.startAddress != oldWidget.startAddress ||
        widget.targetAddress != oldWidget.targetAddress) {
      shouldUpdate = true;
    }
    if (widget.fromClient != oldWidget.fromClient) {
      shouldUpdate = true;
    }
    if (widget.estimatedTime != oldWidget.estimatedTime) {
      shouldUpdate = true;
    }

    if (shouldUpdate) {
      _setMarkersAndPolyline();
      _moveCameraToFitAllPoints();
    }
  }

  // دالة جديدة للتعامل مع Start و Target فقط
  void _moveCameraToFitStartAndTarget() {
    if (_mapController == null || widget.startLocation == null || widget.targetLocation == null) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final mapHeight = size.height;
    final mapWidth = size.width;

    // حساب padding مناسب للـ top (أكبر من العادي)
    double padding = _calculateDynamicPaddingForTop(mapHeight, mapWidth);

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
    if (_mapController == null) return;

    List<LatLng> allPoints = [];
    if (widget.startLocation != null) allPoints.add(widget.startLocation!);
    if (widget.targetLocation != null) allPoints.add(widget.targetLocation!);
    allPoints.addAll(widget.clientLocations);
    allPoints.addAll(widget.polylinePoints);

    if (allPoints.length < 2) return;

    // الحصول على حجم الخريطة
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final mapHeight = size.height;
    final mapWidth = size.width;

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

    // حساب padding مناسب للـ top (أكبر من العادي)
    double padding = _calculateDynamicPaddingForTop(mapHeight, mapWidth);

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }

  // دالة لحساب padding أكبر للتعامل مع مشكلة الـ top
  double _calculateDynamicPaddingForTop(double mapHeight, double mapWidth) {
    // حساب أصغر بُعد (العرض أو الارتفاع)
    double smallestDimension = min(mapHeight, mapWidth);

    // حساب padding أساسي بنسب أكبر عشان نعوض مشكلة الـ top
    double paddingPercentage;

    if (smallestDimension < 200) {
      paddingPercentage = 0.18; // 18% للخرائط الصغيرة جداً
    } else if (smallestDimension < 300) {
      paddingPercentage = 0.22; // 22% للخرائط الصغيرة
    } else if (smallestDimension < 500) {
      paddingPercentage = 0.25; // 25% للخرائط المتوسطة
    } else {
      paddingPercentage = 0.28; // 28% للخرائط الكبيرة
    }

    double calculatedPadding = smallestDimension * paddingPercentage;

    // تأكد من أن padding لا يقل عن 35 ولا يزيد عن 150
    return calculatedPadding.clamp(35.0, 150.0);
  }

  // دالة لحساب padding ديناميكي بناءً على حجم الخريطة (للتوافق مع الدوال القديمة)
  double _calculateDynamicPadding(double mapHeight, double mapWidth) {
    // استخدام نفس الدالة الجديدة
    return _calculateDynamicPaddingForTop(mapHeight, mapWidth);
  }

  Future<void> _createCustomMarkerIcons(double size) async {
    _startMarkerIcon = await _createLocationGlowMarker(Colors.green, size);
    _targetMarkerIcon = await _createLocationGlowMarker(Colors.blue, size);
    _clientMarkerIcon = await _createLocationGlowMarker(Colors.red, size);
    _setMarkersAndPolyline();
  }

  double _calculateMarkerSizeByZoom(double zoom) {
    const minZoom = 10.0;
    const maxZoom = 20.0;
    final clampedZoom = zoom.clamp(minZoom, maxZoom);
    final normalized = (clampedZoom - minZoom) / (maxZoom - minZoom);
    return 20 + (normalized * (35 - 20));
  }

  void _updateMarkerIconsByZoom() {
    final size = _calculateMarkerSizeByZoom(_currentZoom);
    _createCustomMarkerIcons(size);
  }

  Future<BitmapDescriptor> _createLocationGlowMarker(Color glowColor, double size) async {
    return await _createGlowMarkerFromWidget(glowColor: glowColor, size: size);
  }

  Future<BitmapDescriptor> _createGlowMarkerFromWidget({
    required Color glowColor,
    double size = 35.0,
  }) async {
    final double glowSize = size;
    final widget = Container(
      width: glowSize,
      height: glowSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: glowColor.withAlpha(50),
        ),
        child: Container(
          width: glowSize * 0.6,
          height: glowSize * 0.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: glowColor,
          ),
        ),
      ),
    );

    return await _widgetToBitmapDescriptor(widget, glowSize);
  }

  Future<BitmapDescriptor> _widgetToBitmapDescriptor(Widget widget, double size) async {
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();
    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    final RenderView renderView = RenderView(
      view: ui.PlatformDispatcher.instance.implicitView!,
      configuration: ViewConfiguration(
        physicalConstraints: BoxConstraints.tightFor(width: size, height: size),
        logicalConstraints: BoxConstraints.tightFor(width: size, height: size),
        devicePixelRatio: ui.PlatformDispatcher.instance.views.first.devicePixelRatio,
      ),
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: boundary,
      ),
    );

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: boundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(width: size, height: size, child: widget),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    initMapStyle();
    _setMarkersAndPolyline();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveCameraToFitAllPoints();
    });
  }

  void initMapStyle() async {
    var lightStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/light_map_style.json');
    var darkStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');
    _mapController?.setMapStyle(context.isDarkMode ? darkStyle : lightStyle);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveCameraToFitAllPoints();
    });
  }

  // دالة لحساب المسافة بين نقطتين
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // بالمتر
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

  // دالة لحساب النقاط الوسطية بين نقطتين
  List<LatLng> _generateStepPoints(LatLng start, LatLng end, double stepDistance) {
    List<LatLng> stepPoints = [];

    double totalDistance = _calculateDistance(start, end);
    if (totalDistance <= stepDistance) {
      return stepPoints; // مسافة قصيرة جداً، مش محتاجين steps
    }

    int numberOfSteps = (totalDistance / stepDistance).floor();

    for (int i = 1; i <= numberOfSteps; i++) {
      double ratio = (stepDistance * i) / totalDistance;
      double lat = start.latitude + (end.latitude - start.latitude) * ratio;
      double lng = start.longitude + (end.longitude - start.longitude) * ratio;
      stepPoints.add(LatLng(lat, lng));
    }

    return stepPoints;
  }

  // دالة لإضافة الدوائر الرمادية
  void _addStepCircles() {
    _circles.clear();

    if (widget.polylinePoints.isEmpty) return;

    // حساب حجم الدائرة بناءً على الزوم
    double circleRadius = _calculateCircleRadiusByZoom(_currentZoom);
    const double stepDistance = 50.0; // المسافة بين كل step (50 متر)

    // إضافة steps بين start location وبداية polyline
    if (widget.startLocation != null) {
      LatLng polylineStart = widget.polylinePoints.first;
      List<LatLng> startSteps = _generateStepPoints(widget.startLocation!, polylineStart, stepDistance);

      for (int i = 0; i < startSteps.length; i++) {
        _circles.add(Circle(
          circleId: CircleId('start_step_$i'),
          center: startSteps[i],
          radius: circleRadius,
          fillColor: Colors.grey.withOpacity(0.4),
          strokeColor: Colors.grey.withOpacity(0.6),
          strokeWidth: 1,
        ));
      }
    }

    // إضافة steps بين نهاية polyline و target location
    if (widget.targetLocation != null) {
      LatLng polylineEnd = widget.polylinePoints.last;
      List<LatLng> endSteps = _generateStepPoints(polylineEnd, widget.targetLocation!, stepDistance);

      for (int i = 0; i < endSteps.length; i++) {
        _circles.add(Circle(
          circleId: CircleId('end_step_$i'),
          center: endSteps[i],
          radius: circleRadius,
          fillColor: Colors.grey.withOpacity(0.4),
          strokeColor: Colors.grey.withOpacity(0.6),
          strokeWidth: 1,
        ));
      }
    }
  }

  // دالة لحساب حجم الدائرة بناءً على الزوم
  double _calculateCircleRadiusByZoom(double zoom) {
    const minZoom = 10.0;
    const maxZoom = 20.0;
    final clampedZoom = zoom.clamp(minZoom, maxZoom);
    final normalized = (clampedZoom - minZoom) / (maxZoom - minZoom);
    return 3 + (normalized * (8 - 3)); // من 3 لـ 8 متر
  }

  void _setMarkersAndPolyline() {
    _markers.clear();
    _polylines.clear();

    if (widget.startLocation != null && _startMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: widget.startLocation!,
        icon: _startMarkerIcon!,
        infoWindow: (widget.startAddress != null && (widget.startAddress?.isNotEmpty ?? false)) ? InfoWindow(title: widget.startAddress ?? '') : InfoWindow(),
      ));
    }

    if (widget.targetLocation != null && _targetMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('target'),
        position: widget.targetLocation!,
        icon: _targetMarkerIcon!,
        infoWindow: (widget.targetAddress != null && (widget.targetAddress?.isNotEmpty ?? false)) ? InfoWindow(title: widget.targetAddress ?? '') : InfoWindow(),
      ));
    }

    for (int i = 0; i < widget.clientLocations.length; i++) {
      if (_clientMarkerIcon != null) {
        _markers.add(Marker(
          markerId: MarkerId('client_$i'),
          position: widget.clientLocations[i],
          icon: _clientMarkerIcon!,
          infoWindow: i < widget.clientAddresses.length
              ? InfoWindow(
            // title: 'العميل ${i + 1}',
            title: i < widget.clientAddresses.length ? widget.clientAddresses[i] : '',
          )
              : InfoWindow(),
        ));
      }
    }

    if (widget.polylinePoints.isNotEmpty) {
      final clientsCount = widget.clientLocations.length;
      List<Color> gradientColors;
      if (clientsCount == 0) {
        gradientColors = [Colors.green, Colors.blue];
      } else if (clientsCount == 1) {
        gradientColors = [Colors.green, Colors.red, Colors.blue];
      } else {
        gradientColors = [Colors.green, Colors.red, Colors.red, Colors.blue];
      }
      _polylines.addAll(_buildGradientPolyline(widget.polylinePoints, gradientColors));
    }

    // إضافة الدوائر الرمادية
    _addStepCircles();

    if (_carMarker != null) {
      _markers.add(_carMarker!);
    }

    setState(() {});
  }

  List<Polyline> _buildGradientPolyline(List<LatLng> points, List<Color> colors) {
    List<Polyline> gradientPolylines = [];
    if (points.length < 2 || colors.length < 2) return gradientPolylines;
    final int segmentCount = points.length - 1;
    for (int i = 0; i < segmentCount; i++) {
      final double t = i / segmentCount;
      final double colorIndex = t * (colors.length - 1);
      final int startColorIndex = colorIndex.floor();
      final int endColorIndex = colorIndex.ceil();
      final double localT = colorIndex - startColorIndex;
      final Color interpolatedColor = Color.lerp(
        colors[startColorIndex],
        colors[endColorIndex],
        localT,
      )!;
      gradientPolylines.add(
        Polyline(
          polylineId: PolylineId('gradient_$i'),
          points: [points[i], points[i + 1]],
          color: interpolatedColor,
          width: 4,
        ),
      );
    }
    return gradientPolylines;
  }

  void _updateCarMarker(Marker? marker) {
    setState(() {
      _carMarker = marker;
    });
    _setMarkersAndPolyline();
  }

  void removeCarMarker() {
    setState(() {
      _carMarker = null;
    });
    _setMarkersAndPolyline();
  }

  LatLng _getInitialCenter() {
    return widget.startLocation ?? widget.targetLocation ?? const LatLng(30.033333, 31.233334);
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
    Widget mapWidget = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _getInitialCenter(), zoom: _currentZoom),
      markers: _markers,
      polylines: _polylines,
      circles: _circles, // إضافة الدوائر للخريطة
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
        if ((_currentZoom - position.zoom).abs() >= 0.5) {
          _currentZoom = position.zoom;
          _updateMarkerIconsByZoom();
          _addStepCircles(); // تحديث حجم الدوائر مع الزوم
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
        if (widget.fromClient == true && _mapController != null)
          GoogleMapCarMarkerWidget(
            onCarMarkerUpdated: _updateCarMarker,
            mapController: _mapController!,
            size: _currentZoom,
          ),
        if (widget.fromClient == false && _mapController != null)
          DriverCarMarkerWidget(
            onCarMarkerUpdated: _updateCarMarker,
            mapController: _mapController!,
            size: _currentZoom,
            time: widget.estimatedTime,
          ),
      ],
    );
  }
}