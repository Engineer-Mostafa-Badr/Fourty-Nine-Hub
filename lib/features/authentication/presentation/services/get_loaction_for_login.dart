
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Request permission & get current position
Future<Position> _getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // Check permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
        'Location permissions are permanently denied, we cannot request.');
  }

  // Get position
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

/// Get latitude
Future<double> getLat() async {
  final pos = await _getCurrentPosition();
  return pos.latitude;
}

/// Get longitude
Future<double> getLng() async {
  final pos = await _getCurrentPosition();
  return pos.longitude;
}

/// Get human-readable address
Future<String> getAddress() async {
  final pos = await _getCurrentPosition();

  List<Placemark> placemarks =
  await placemarkFromCoordinates(pos.latitude, pos.longitude);

  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    return "${place.thoroughfare}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
  }
  return "Unknown address";
}
