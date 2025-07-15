import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/enums/trip_states_enum.dart';
import '../../controllers/cubits/ride_cubit.dart';

class GoogleMapCarMarkerWidget extends StatefulWidget {
  final Function(Marker?) onCarMarkerUpdated;

  const GoogleMapCarMarkerWidget({
    super.key,
    required this.onCarMarkerUpdated,
  });

  @override
  State<GoogleMapCarMarkerWidget> createState() => _GoogleMapCarMarkerWidgetState();
}

class _GoogleMapCarMarkerWidgetState extends State<GoogleMapCarMarkerWidget> {
  double _lastAngle = 0;
  BitmapDescriptor? _carIcon;
  StreamSubscription? _rideSub;

  @override
  void initState() {
    super.initState();
    _loadCarIcon();
    _subscribeToRideCubit();
  }

  @override
  void dispose() {
    _rideSub?.cancel();
    super.dispose();
  }

  void _loadCarIcon() async {
    _carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(8, 8)),
      'assets/images/car_for_tracking.png',
    );
    setState(() {});
  }

  void _subscribeToRideCubit() {
    _rideSub = context.read<RideCubit>().stream.listen((rideState) {
      final trip = rideState.requestedTrip;
      final currentLocation = rideState.driverLocation;
      final previousLocation = rideState.previousDriverLocation;

      if (trip?.status == TripState.started.name && currentLocation != null) {
        double newAngle = _lastAngle;

        if (previousLocation != null) {
          newAngle = _calculateBearing(previousLocation, currentLocation);
        }

        final marker = Marker(
          markerId: const MarkerId('car'),
          position: currentLocation,
          rotation: newAngle,
          icon: _carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          flat: true,
          anchor: const Offset(0.5, 0.5),
        );

        _lastAngle = newAngle;

        widget.onCarMarkerUpdated(marker); // Notify parent
      } else {
        widget.onCarMarkerUpdated(null); // Remove marker
      }
    });
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * (pi / 180);
    final double lat2 = to.latitude * (pi / 180);
    final double deltaLng = (to.longitude - from.longitude) * (pi / 180);

    final double y = sin(deltaLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);
    final double bearing = atan2(y, x);

    return (bearing * (180 / pi) + 360) % 360;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}