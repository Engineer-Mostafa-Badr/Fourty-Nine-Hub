import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationService {
  final double distanceThreshold = 0.2;
  Position? lastPosition;
  Timer? _timer;

  // Flag to prevent multiple permission requests
  bool _isRequestingPermission = false;

  final _locationController = StreamController<Position>.broadcast();
  Stream<Position> get locationUpdates => _locationController.stream;

  void startLocationTracking() {
    stopLocationTracking();

    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      _checkAndUpdateLocation();
    });

    _checkAndUpdateLocation();
  }

  void stopLocationTracking() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkAndUpdateLocation() async {
    bool hasPermission = await _checkPermissions();
    if (!hasPermission) return;

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (lastPosition == null || _hasMovedEnoughDistance(currentPosition)) {
        lastPosition = currentPosition;
        _locationController.add(currentPosition);
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

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

  Future<bool> _checkPermissions() async {
    // If permission is already being requested, skip this step
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    if (_isRequestingPermission) {
      print('Permission request is already in progress.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // Request permission if it is denied
    if (permission == LocationPermission.denied) {
      _isRequestingPermission = true;  // Mark that we are requesting permission

      permission = await Geolocator.requestPermission();

      _isRequestingPermission = false;  // Reset after the request completes

      if (permission == LocationPermission.denied) {
        print('User denied the permission.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Permission permanently denied. Cannot request again.');
      return false;
    }

    // Permission granted
    return true;
  }

  void dispose() {
    stopLocationTracking();
    _locationController.close();
  }
}
