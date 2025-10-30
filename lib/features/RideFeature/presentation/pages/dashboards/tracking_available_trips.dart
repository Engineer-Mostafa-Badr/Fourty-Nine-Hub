import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/available_trip_card.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/ride_mode_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/build_map_marker.dart';
import 'package:fourtyninehub/helpers/marker_generator.dart';

class TrackingAvailableTrips extends StatefulWidget {
  const TrackingAvailableTrips({super.key, required this.params});

  final RideModeParams params;

  @override
  State<TrackingAvailableTrips> createState() => _TrackingAvailableTripsState();
}

class _TrackingAvailableTripsState extends State<TrackingAvailableTrips> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  CameraPosition? _initialCameraPosition;
  bool _isLoading = true;

  // List<AvailableTripEntity> _trips = [];
  AvailableTripEntity? _selectedTrip;

  static const String _manIconPath = 'assets/icons/man.png';
  static const String _womanIconPath = 'assets/icons/woman.png';

  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _targetMarkerIcon;

  @override
  void initState() {
    super.initState();

  }

  Future<void> _fitBounds(LatLngBounds bounds) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    const double padding = 50.0;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }

  void _initializeFromTrips(List<AvailableTripEntity> trips) {
    // _trips = trips;
    if (context.read<DashboardsCubit>().newAvailableRideTrips.isEmpty) {
      _initialCameraPosition = const CameraPosition(
        target: LatLng(30.0444, 31.2357),
        zoom: 10.0,
      );
      _markers = {};
      _polylines = {};
      _selectedTrip = null;
      _isLoading = false;
      setState(() {});
      return;
    }
    _selectedTrip = context.read<DashboardsCubit>().newAvailableRideTrips.first;
      _initialCameraPosition = CameraPosition(
      target: LatLng(
        _selectedTrip?.route?.pickupPoint?.latitude ?? 30.0444,
        _selectedTrip?.route?.pickupPoint?.longitude ?? 31.2357,
      ),
      zoom: 12.0,
    );
    _setCustomMarkersFromTrips();
  }

  void _setCustomMarkersFromTrips() async {
    print("_setCustomMarkersFromTrips ${context.read<DashboardsCubit>().newAvailableRideTrips.length}");
    if (context.read<DashboardsCubit>().newAvailableRideTrips.isEmpty) return;
    final markerWidgets = context.read<DashboardsCubit>().newAvailableRideTrips.map((t) {
      final isMale = (t.clientDetails?.gender?.toLowerCase() ?? '') == 'male';
      final name = (t.clientDetails?.firstName ?? '').isNotEmpty ? (t.clientDetails!.firstName!) : '';
      return BuildMapMarker(
        manIconPath: _manIconPath,
        womanIconPath: _womanIconPath,
        name: name,
        isMale: isMale,
      );
    }).toList();
    print("markerWidgets ${markerWidgets.length}");
    MarkerGenerator(markerWidgets, (bitmaps) {
      final List<Marker> markersList = [];
      for (int i = 0; i < context.read<DashboardsCubit>().newAvailableRideTrips.length && i < bitmaps.length; i++) {
        final trip = context.read<DashboardsCubit>().newAvailableRideTrips[i];
        final pickup = trip.route?.pickupPoint;
        if (pickup?.latitude == null || pickup?.longitude == null) continue;
      markersList.add(Marker(
          markerId: MarkerId('trip_${trip.id ?? i}'),
          position: LatLng(pickup!.latitude!, pickup.longitude!),
          icon: BitmapDescriptor.fromBytes(bitmaps[i]),
          onTap: () => _onUserMarkerTap(trip),
        ));
      }
      if (mounted) {
        setState(() {
          _markers = markersList.toSet();
          _isLoading = false;
        });
        // Render polyline for the initially selected trip if available
        if (_selectedTrip != null) {
          _renderMarkersAndPolyline(_selectedTrip!);
        }
      }
    }).generate(context);
  }

  LatLngBounds _calculateBoundsFromPolyline(List<LatLng> points) {
    double minLat = points.map((p) => p.latitude).reduce(min);
    double maxLat = points.map((p) => p.latitude).reduce(max);
    double minLng = points.map((p) => p.longitude).reduce(min);
    double maxLng = points.map((p) => p.longitude).reduce(max);
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _renderMarkersAndPolyline(AvailableTripEntity trip) async {
    await _ensureStartTargetMarkerIcons();
    final List<Marker> markers = [];
    final pickup = trip.route?.pickupPoint;
    final drop = trip.route?.dropPoint;

    if (pickup?.latitude != null && pickup?.longitude != null) {
      markers.add(Marker(
        markerId: MarkerId('pickup_${trip.id}'),
        position: LatLng(pickup!.latitude!, pickup.longitude!),
        infoWindow: const InfoWindow(title: 'Pickup',snippet: 'aaa'),
        icon: _startMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }
    if (drop?.latitude != null && drop?.longitude != null) {
      markers.add(Marker(
        markerId: MarkerId('drop_${trip.id}'),
        position: LatLng(drop!.latitude!, drop.longitude!),
        infoWindow: const InfoWindow(title: 'Dropoff'),
        icon: _targetMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    final List<LatLng> points = (trip.route?.pickupToDropPolyline ?? [])
        .map((p) => LatLng(p.longitude, p.latitude))
        .toList();
    if (points.isNotEmpty) {
    final polyline = Polyline(
        polylineId: PolylineId('route_${trip.id ?? DateTime.now().millisecondsSinceEpoch}'),
      points: points,
      color: AppColors.SECONDARY_COLOR,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    setState(() {
        _markers = {
          ..._markers,
          ...markers,
        };
      _polylines = {polyline};
        _isLoading = false;
      });
      _fitBounds(_calculateBoundsFromPolyline(points));
    } else {
        setState(() {
        _markers = {
          ..._markers,
          ...markers,
        };
        _polylines = {};
          _isLoading = false;
        });
      if (_controller.isCompleted && markers.isNotEmpty) {
        final controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(markers.first.position, 12),
        );
      }
    }

    // Also render a user marker at the start of the polyline using BuildMapMarker
    _addUserMarkerAtPolylineStart(trip);
  }

  void _selectTrip(AvailableTripEntity trip) {
    setState(() {
      _selectedTrip = trip;
    });
    _renderMarkersAndPolyline(trip);
  }

  void _onUserMarkerTap(AvailableTripEntity trip) {
    print("_onUserMarkerTap");
    setState(() {
      context.read<DashboardsCubit>().newAvailableRideTrips.removeWhere((t) => t.id == trip.id);
      context.read<DashboardsCubit>().newAvailableRideTrips.insert(0, trip);
      _selectedTrip = trip;
    });
    _renderMarkersAndPolyline(trip);
  }

  Future<void> _ensureStartTargetMarkerIcons() async {
    if (_startMarkerIcon != null && _targetMarkerIcon != null) return;
    // Fixed size similar to CaptainShare; could be dynamic by zoom if needed
    const double size = 72;
    _startMarkerIcon = await _createMarkerWithLetter('A', const Color(0xFF2196F3), size);
    _targetMarkerIcon = await _createMarkerWithLetter('B', const Color(0xFF4CAF50), size);
  }

  Future<BitmapDescriptor> _createMarkerWithLetter(String letter, Color color, double size) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2, glowPaint);

      final mainPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size / 2, size / 2), (size / 2) * 0.7, mainPaint);

      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(size / 2, size / 2), (size / 2) * 0.7, borderPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: letter,
                            style: TextStyle(
                              color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2);
      textPainter.paint(canvas, textOffset);

      final picture = recorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      picture.dispose();
      image.dispose();
      return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
    } catch (_) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  void _addUserMarkerAtPolylineStart(AvailableTripEntity trip) {
    final List<LatLng> polyPoints = trip.route?.pickupToDropPolyline ?? [];
    final LatLng? startPoint = polyPoints.isNotEmpty ? polyPoints.first : null;
    if (startPoint == null) return;

    // final isMale = (trip.clientDetails?.gender?.toLowerCase() ?? '') == 'male';
    // final name = (trip.clientDetails?.firstName ?? '').isNotEmpty ? (trip.clientDetails!.firstName!) : '';

    // final markerWidget = BuildMapMarker(
    //   manIconPath: _manIconPath,
    //   womanIconPath: _womanIconPath,
    //   name: name,
    //   isMale: isMale,
    // );
    Set<Marker> usersMarkers = {};
    final markerWidgets = context.read<DashboardsCubit>().newAvailableRideTrips.map((t) {
      final isMale = (t.clientDetails?.gender?.toLowerCase() ?? '') == 'male';
      final name = (t.clientDetails?.firstName ?? '').isNotEmpty ? (t.clientDetails!.firstName!) : '';
      LatLng position = LatLng(trip.route!.pickupPoint?.latitude??0, trip.route?.pickupPoint?.longitude??0);
      usersMarkers.add(
          Marker(
            markerId: MarkerId('user_start_${trip.id ?? DateTime.now().millisecondsSinceEpoch}'),
            position: position,
            zIndex: 2.0,
          )
      );
      return BuildMapMarker(
        manIconPath: _manIconPath,
        womanIconPath: _womanIconPath,
        name: name,
        isMale: isMale,
      );
    }).toList();
    MarkerGenerator(markerWidgets, (bitmaps) {
      if (bitmaps.isEmpty) return;

      // Create a marker for each user
      final List<Marker> userMarkers = [];

      for (int i = 0; i < context.read<DashboardsCubit>().newAvailableRideTrips.length && i < bitmaps.length; i++) {
        final trip = context.read<DashboardsCubit>().newAvailableRideTrips[i];
        final pickup = trip.route?.pickupPoint;
        if (pickup?.latitude == null || pickup?.longitude == null) continue;

        userMarkers.add(
          Marker(
            markerId: MarkerId('user_${trip.id ?? i}'),
            position: LatLng(pickup!.latitude!, pickup.longitude!),
            icon: BitmapDescriptor.fromBytes(bitmaps[i]),
            zIndex: 2.0,
            onTap: () => _onUserMarkerTap(trip),
      ),
    );
  }

      if (!mounted) return;
      setState(() {
        _markers = {
          ..._markers,
          ...userMarkers,
        };
      });
    }).generate(context);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardsCubit, DashboardsState>(
      listener: (context, state) {
        if ((state.newAvailableRideTrips ?? []).isNotEmpty) {
          _initializeFromTrips(state.newAvailableRideTrips!);
        } else if ((state.newAvailableRideTrips ?? []).isEmpty && state.isSuccess) {
          _initializeFromTrips([]);
        }
      },
      builder: (context, state) {
        return Stack(
        children: [
          if (_initialCameraPosition == null)
            const Center(child: CustomCircularProgressIndicator())
          else
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition!,
              onMapCreated: _onMapCreated,
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
                onTap: (_) {
                  // Optional: select different trip via tapping markers, etc.
                },
            ),

            if (context.read<DashboardsCubit>().isLoadingAvailableRideTrips)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CustomCircularProgressIndicator(),
              ),
            ),
          if (context.read<DashboardsCubit>().newAvailableRideTrips.isNotEmpty && !_isLoading)Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 420,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                  for (int i = 0; i < context.read<DashboardsCubit>().newAvailableRideTrips.length; i++)
                      AnimatedPositioned(
                      key: ValueKey(context.read<DashboardsCubit>().newAvailableRideTrips[i].id),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        // نزود المسافة بين كل كارت والتاني
                      bottom: 15.0 * (context.read<DashboardsCubit>().newAvailableRideTrips.length - 1 - i),
                        left: 0,
                        right: 0,
                        child: Opacity(
                          // الكروت اللي تحت تبقى أغمق شوية
                          opacity: i == 0
                              ? 1.0
                              : 1.0 -
                                  (0.1 *
                                      i.clamp(0,
                                          2)), // أول كارت واضح، اللي تحته أقل وضوحًا
                          child: FractionallySizedBox(
                            widthFactor:
                          0.98, // نخلي كل الكروت عرضها أقل شوية عشان الحواف تبان
                            alignment: Alignment.bottomCenter,
                          child: AvailableTripCard(
                            trip: context.read<DashboardsCubit>().newAvailableRideTrips[i],
                            params: widget.params,
                            onCancel: (_) {
                              // setState(() {
                              //   _trips.removeWhere((e)=>e.id==_trips[i].id);
                              // });
                              print("context.read<DashboardsCubit>().newAvailableRideTrips.length ${context.read<DashboardsCubit>().newAvailableRideTrips.length}");
                              if(context.read<DashboardsCubit>().newAvailableRideTrips.length==1){
                                context.read<DashboardsCubit>().refuseNewTripOffer(context.read<DashboardsCubit>().newAvailableRideTrips[i].id??'');
                                context.read<DashboardsCubit>().getAvailableTrackingTrips(context);
                                print("context.read<DashboardsCubit>().newAvailableRideTrips.length ${context.read<DashboardsCubit>().newAvailableRideTrips.length}");
                              }
                              if(context.read<DashboardsCubit>().newAvailableRideTrips.isNotEmpty){
                                context.read<DashboardsCubit>().refuseNewTripOffer(context.read<DashboardsCubit>().newAvailableRideTrips[i].id??'');
                                _selectTrip(context.read<DashboardsCubit>().newAvailableRideTrips[i]);
                                print("context.read<DashboardsCubit>().newAvailableRideTrips.length ${context.read<DashboardsCubit>().newAvailableRideTrips.length}");
                              }
                              // You can call _removeCurrentCard() if desired
                            }, showRemoveButton: true,
                            ),
                          ),
                        ),
                      ),
                  ].reversed.toList(),
                ),
              ),
            ),
            // if (_trips.isNotEmpty && !_isLoading)
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //     child: Padding(
            //       padding: const EdgeInsets.only(bottom: 12.0),
            //       child: AvailableTripCard(
            //         trip: _selectedTrip ?? _trips.first,
            //         params: widget.params,
            //         onCancel: (_) {
            //           // You can call _removeCurrentCard() if desired
            //         },
            //       ),
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}
