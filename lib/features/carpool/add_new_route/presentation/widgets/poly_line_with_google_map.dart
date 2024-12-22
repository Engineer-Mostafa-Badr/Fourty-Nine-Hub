import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Function to decode polyline and extract start and end points
List<List<double>> decodePolyline(String polyline) {
  List<List<double>> coordinates = [];
  int index = 0;
  int lat = 0;
  int lng = 0;

  while (index < polyline.length) {
    int shift = 0;
    int result = 0;

    int byte;
    do {
      byte = polyline.codeUnitAt(index++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);

    int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lat += deltaLat;

    shift = 0;
    result = 0;

    do {
      byte = polyline.codeUnitAt(index++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);

    int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lng += deltaLng;

    coordinates.add([lat / 1e5, lng / 1e5]);
  }

  return coordinates;
}

// Function to open Google Maps with the polyline route
Future<void> openGoogleMapsWithRoute(String polyline) async {
  // Decode the polyline to get the start and end coordinates
  final decodedPoints = decodePolyline(polyline);

  // Extract the start and end coordinates
  final String start = '${decodedPoints.first[0]},${decodedPoints.first[1]}';
  final String end = '${decodedPoints.last[0]},${decodedPoints.last[1]}';

  // Construct the URL for Google Maps
  const String baseUrl = 'https://www.google.com/maps/dir/?api=1';
  final String url =
      '$baseUrl&origin=$start&destination=$end&path=enc:$polyline';

  // Launch Google Maps with the constructed URL
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
