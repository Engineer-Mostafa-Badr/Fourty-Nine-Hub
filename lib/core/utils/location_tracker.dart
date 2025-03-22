import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationService {
  // Distance threshold in meters
  final double distanceThreshold = 300;
  Position? lastPosition;
  Timer? _timer;

  // Stream controller to broadcast new locations
  final _locationController = StreamController<Position>.broadcast();
  Stream<Position> get locationUpdates => _locationController.stream;

  // Start periodic location checks
  void startLocationTracking() {
    // Stop any existing timer
    stopLocationTracking();

    // Create a new timer that fires every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      _checkAndUpdateLocation();
    });

    // Check immediately once
    _checkAndUpdateLocation();
  }

  // Stop tracking
  void stopLocationTracking() {
    _timer?.cancel();
    _timer = null;
  }

  // Check location with permission verification
  Future<void> _checkAndUpdateLocation() async {
    // Always check permission status first
    bool hasPermission = await _checkPermissions();
    if (!hasPermission) {
      return; // Skip if no permission
    }

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // If this is first position or we've moved enough
      if (lastPosition == null || _hasMovedEnoughDistance(currentPosition)) {
        lastPosition = currentPosition;
        _locationController.add(currentPosition);
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Check if we've moved at least the threshold distance
  bool _hasMovedEnoughDistance(Position currentPosition) {
    if (lastPosition == null) return true;

    double distance = Geolocator.distanceBetween(
      lastPosition!.latitude,
      lastPosition!.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    return distance >= distanceThreshold;
  }

  // Check and request permissions if needed
  Future<bool> _checkPermissions() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Request to enable location services
      print('Location services are disabled, requesting to enable');
      // On most platforms, we need to direct users to settings
      // This doesn't directly enable services but prompts the user
      await Geolocator.openLocationSettings();

      // Check again if the user enabled services
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services remain disabled after request');
        return false;
      }
    }

    // Check permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // Handle different permission states
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions permanently denied');
      // Direct user to app settings to change permissions
      await Geolocator.openAppSettings();
      return false;
    }

    // We have permission
    return true;
  }

  // Clean up resources
  void dispose() {
    stopLocationTracking();
    _locationController.close();
  }
}