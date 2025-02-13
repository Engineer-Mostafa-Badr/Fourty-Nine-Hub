// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:latlong2/latlong.dart';

// class OpenRouteServiceMap extends StatefulWidget {
//   final String apiKey;

//   OpenRouteServiceMap({required this.apiKey});

//   @override
//   _OpenRouteServiceMapState createState() => _OpenRouteServiceMapState();
// }

// class _OpenRouteServiceMapState extends State<OpenRouteServiceMap> {
//   late MapController _mapController;
//   double _currentZoom = 12.0;
//   late LatLng _center;
//   List<LatLng> _polylinePoints = [];

//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//     _center = LatLng(0.0, 0.0); // Default center
//     _fetchRoute(); // Fetch the route on init
//   }

//   Future<void> _fetchRoute() async {
//     try {
//       final startCoordinates = '-73.935242,40.730610';
//       final endCoordinates = '-74.0060,40.7128';

//       final response = await http.get(
//         Uri.parse(
//           'https://api.openrouteservice.org/v2/directions/driving-car?api_key=${widget.apiKey}&start=$startCoordinates&end=$endCoordinates',
//         ),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data != null &&
//             data['routes'] != null &&
//             data['routes'].isNotEmpty) {
//           final List<dynamic> coordinates =
//               data['routes'][0]['geometry']['coordinates'];
//           _polylinePoints =
//               coordinates.map((point) => LatLng(point[1], point[0])).toList();
//           _center = _polylinePoints.isNotEmpty
//               ? _polylinePoints.first
//               : LatLng(0.0, 0.0);
//         } else {
//           debugPrint("No routes found in response.");
//         }
//       } else {
//         debugPrint("Failed to fetch route: ${response.reasonPhrase}");
//       }
//     } catch (e) {
//       debugPrint("Error fetching route: $e");
//     }
//     setState(() {}); // Update the UI even if fetching failed
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: _center,
//               initialZoom: _currentZoom,
//               minZoom: 6.0,
//               maxZoom: 18.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 // OpenRouteService tile URL (replace with actual endpoint if needed)
//               ),
//               PolylineLayer(
//                 polylines: [
//                   Polyline(
//                     points: _polylinePoints,
//                     strokeWidth: 4.0,
//                     color: Colors.blue,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           // Add additional UI elements such as zoom buttons
//         ],
//       ),
//     );
//   }
// }
