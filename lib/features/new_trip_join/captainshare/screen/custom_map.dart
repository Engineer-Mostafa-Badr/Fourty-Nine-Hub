import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/car_marker_on_client_side_google_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/driver_car_marker_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
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
  Marker? _carMarker;

  final LatLngBounds egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 24.7),
    northeast: const LatLng(31.7, 36.0),
  );

  LatLng? _latestStartLocation;
  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _targetMarkerIcon;
  BitmapDescriptor? _clientMarkerIcon;
  double _currentZoom = 12.0;

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

    if (widget.targetLocation != oldWidget.targetLocation ||
        widget.clientLocations != oldWidget.clientLocations ||
        widget.polylinePoints != oldWidget.polylinePoints ||
        widget.startAddress != oldWidget.startAddress ||
        widget.targetAddress != oldWidget.targetAddress ||
        widget.clientAddresses != oldWidget.clientAddresses) {
      shouldUpdate = true;
    }
    if (widget.fromClient != oldWidget.fromClient ) {
      shouldUpdate = true;
    }
    if (widget.estimatedTime != oldWidget.estimatedTime ) {
          shouldUpdate = true;
        }

    if (shouldUpdate) {
      _setMarkersAndPolyline();
    }
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
      if (widget.startLocation != null) {
        _mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: widget.startLocation!, zoom: _currentZoom),
          ),
        );
      }
    });
  }

  void initMapStyle() async {
    var lightStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/light_map_style.json');
    var darkStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');
    _mapController?.setMapStyle(context.isDarkMode ? darkStyle : lightStyle);
  }

  void _setMarkersAndPolyline() {
    _markers.clear();
    _polylines.clear();

    print("startAddress marker ${widget.startAddress}");
    if (widget.startLocation != null && _startMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: widget.startLocation!,
        icon: _startMarkerIcon!,
        infoWindow: (widget.startAddress!=null&&(widget.startAddress?.isNotEmpty??false))?InfoWindow(title: widget.startAddress ?? ''):InfoWindow(),
      ));
    }

    if (widget.targetLocation != null && _targetMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('target'),
        position: widget.targetLocation!,
        icon: _targetMarkerIcon!,
        infoWindow:  (widget.targetAddress!=null&&(widget.targetAddress?.isNotEmpty??false))?InfoWindow( title: widget.targetAddress ?? ''):InfoWindow(),
      ));
    }

    for (int i = 0; i < widget.clientLocations.length; i++) {
      if (_clientMarkerIcon != null) {
        _markers.add(Marker(
          markerId: MarkerId('client_$i'),
          position: widget.clientLocations[i],
          icon: _clientMarkerIcon!,
          infoWindow: i < widget.clientAddresses.length ?InfoWindow(
            // title: 'العميل ${i + 1}',
            title: i < widget.clientAddresses.length ? widget.clientAddresses[i] : '',
          ):InfoWindow(),
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
    print('widget.startAddress ${widget.startAddress}');
    Widget mapWidget = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _getInitialCenter(), zoom: _currentZoom),
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
      onCameraMove: (CameraPosition position) {
        if ((_currentZoom - position.zoom).abs() >= 0.5) {
          _currentZoom = position.zoom;
          _updateMarkerIconsByZoom();
        }
      },
    );

    print("widget.fromClient ${widget.fromClient}");
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
          ),
        if (widget.fromClient == false && _mapController != null)
          DriverCarMarkerWidget(
            onCarMarkerUpdated: _updateCarMarker,
            mapController: _mapController!, size: _currentZoom,
            time: widget.estimatedTime,
          ),
      ],
    );
  }
}
