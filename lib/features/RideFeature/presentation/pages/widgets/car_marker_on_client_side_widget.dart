import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/enums/trip_states_enum.dart';
import '../../controllers/cubits/ride_cubit.dart';

class CarMarkerOnClientSideWidget extends StatefulWidget {
  const CarMarkerOnClientSideWidget({super.key});

  @override
  State<CarMarkerOnClientSideWidget> createState() => _CarMarkerOnClientSideWidgetState();
}

class _CarMarkerOnClientSideWidgetState extends State<CarMarkerOnClientSideWidget> {
  // Store the current angle for smooth animation updates.
  // Initial angle can be 0 or derived from a known initial heading.
  // For real-time tracking, it will quickly adjust based on movement.
  double _currentAngle = 0.0;

  @override
  Widget build(BuildContext context) {
    // Watch for changes in the RideState.
    // When RideCubit emits a new state, this widget (and its parent BlocBuilder)
    // will rebuild if the relevant part of the state changes.
    final rideState = context.watch<RideCubit>().state;

    // Check if a driver location is available and if the trip is in a 'started' state.
    // The car marker should only be displayed when tracking is active.
    if (rideState.driverLocation != null &&
        rideState.requestedTrip != null &&
        rideState.requestedTrip!.status == TripState.started.name) {

      final LatLng currentLocation = rideState.driverLocation!;
      final LatLng? previousLocation = rideState.previousDriverLocation;

      double rotation = _currentAngle; // Start with the last known angle

      // Calculate bearing only if there's a previous location to compare against
      if (previousLocation != null) {
        rotation = _calculateBearing(previousLocation, currentLocation);
      }

      // Update the current angle for the TweenAnimationBuilder's start value
      // so that the animation transitions from the actual previous angle.
      // We do not set the _currentAngle directly to 'rotation' here as TweenAnimationBuilder
      // handles the interpolation from the 'begin' value.
      // Instead, we let the TweenAnimationBuilder smoothly update to the new 'rotation'.

      return MarkerLayer(
        markers: [
          Marker(
            point: currentLocation, // Use the driver's real-time location
            width: 60, // Define the width of the marker icon
            height: 60, // Define the height of the marker icon
            child: _RotatingCarIcon(targetAngle: rotation), // Use the new rotating icon widget
          ),
        ],
      );
    }

    // If no driver location is available or the trip is not in a 'started' state,
    // return an empty widget to avoid displaying the marker.
    return const SizedBox.shrink();
  }

  /// Calculates the bearing (direction) in degrees from one LatLng point to another.
  /// This is used to rotate the car icon to face the direction of movement.
  static double _calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * (pi / 180);
    final double lat2 = to.latitude * (pi / 180);
    final double deltaLng = (to.longitude - from.longitude) * (pi / 180);

    final double y = sin(deltaLng) * cos(lat2);
    final double x =
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);
    final double bearing = atan2(y, x);

    // Convert bearing from radians to degrees and normalize to 0-360 range
    return (bearing * (180 / pi) + 360) % 360;
  }
}

/// A private helper widget to handle the smooth rotation of the car icon.
class _RotatingCarIcon extends StatefulWidget {
  final double targetAngle; // in degrees

  const _RotatingCarIcon({required this.targetAngle});

  @override
  State<_RotatingCarIcon> createState() => _RotatingCarIconState();
}

class _RotatingCarIconState extends State<_RotatingCarIcon> {
  // This _currentAngle will be the 'begin' value for the TweenAnimationBuilder,
  // making the animation smooth from the previous actual angle.
  double _currentAnimationBeginAngle = 0;

  @override
  void initState() {
    super.initState();
    _currentAnimationBeginAngle = widget.targetAngle; // Initialize with target angle
  }

  @override
  void didUpdateWidget(covariant _RotatingCarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the begin angle for the next animation cycle to be the *old* target angle
    // (which was the end of the previous animation).
    _currentAnimationBeginAngle = oldWidget.targetAngle;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        // Animate from the angle the car was last seen at
        begin: _currentAnimationBeginAngle,
        // To the new target angle
        end: widget.targetAngle,
      ),
      duration: const Duration(milliseconds: 300), // Smooth animation duration
      builder: (_, angle, child) {
        return Transform.rotate(
          angle: angle * pi / 180, // Convert degrees to radians for Transform.rotate
          child: child,
        );
      },
      // When the animation completes, update the begin angle for the *next* animation
      // to be the current target angle. This prevents jumps.
      onEnd: () {
        _currentAnimationBeginAngle = widget.targetAngle;
      },
      // Your car image asset
      child: Image.asset("assets/images/car_for_tracking.png"),
    );
  }
}