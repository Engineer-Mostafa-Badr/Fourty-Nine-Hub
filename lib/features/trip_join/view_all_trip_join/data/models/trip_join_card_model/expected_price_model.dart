
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../../domain/entities/expected_price_entity.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../domain/entities/expected_price_entity.dart';

class ExpectedPriceTripModel extends ExpectedPriceTripEntity {
  ExpectedPriceTripModel({
    required double pricePerSeat,
    required double distance,
    required double duration,
    required String destinationAddress,
    required String originAddress,
    required List<List<double>> polyline,
    required String type,
  }) : super(
    pricePerSeat: pricePerSeat,
    distance: distance,
    duration: duration,
    destinationAddress: destinationAddress,
    originAddress: originAddress,
    polyline: polyline,
    type: type,
  );

  factory ExpectedPriceTripModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> parsedPolyline = [];

    final polylineData = json['polyline'];
    if (polylineData is String) {
      PolylinePoints polylinePoints = PolylinePoints();
      final decoded = polylinePoints.decodePolyline(polylineData);
      parsedPolyline =
          decoded.map((point) => [point.latitude, point.longitude]).toList();
    } else if (polylineData is List) {
      parsedPolyline = polylineData
          .map<List<double>>(
              (point) => (point as List).map((e) => (e as num).toDouble()).toList())
          .toList();
    }

    return ExpectedPriceTripModel(
      pricePerSeat: (json['pricePerSeat'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 0).toDouble(),
      destinationAddress: json['destinationAddress'] ?? '',
      originAddress: json['originAddress'] ?? '',
      polyline: parsedPolyline,
      type: json['type'] ?? '',
    );
  }
}

/*
class ExpectedPriceTripModel extends ExpectedPriceTripEntity {
  ExpectedPriceTripModel({
    required double price,
    required double distance,
    required double duration,
    required String destinationAddress,
    required String originAddress,
    required  List<List<double>> polyline,
    required String type,
  }) : super(
    price: price,
    distance: distance,
    duration: duration,
    destinationAddress: destinationAddress,
    originAddress: originAddress,
    polyline: polyline,
    type: type,
  );

  factory ExpectedPriceTripModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> parsedPolyline = [];

    if (json['polyline'] != null) {
      if (json['polyline'] is String) {
        // Decode the encoded polyline string
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(json['polyline']);
        parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (json['polyline'] is List) {
        // Use the list directly
        parsedPolyline = (json['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }

    return ExpectedPriceTripModel(
      price: (json['price'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 0).toDouble(),
      destinationAddress: json['destinationAddress'] ?? '',
      originAddress: json['originAddress'] ?? '',
      polyline: parsedPolyline,
      type: json['type'] ?? '',
    );
  }

  // static dynamic _parsePolyline(dynamic polyline) {
  //   if (polyline is String) {
  //     return polyline;
  //   } else if (polyline is List) {
  //     // Expecting list of [lat, lng]
  //     return polyline
  //         .where((point) => point is List && point.length == 2)
  //         .map<Map<String, double>>((point) {
  //       return {
  //         'latitude': point[0].toDouble(),
  //         'longitude': point[1].toDouble(),
  //       };
  //     })
  //         .toList();
  //   }
  //   return null;
  // }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'distance': distance,
      'duration': duration,
      'destinationAddress': destinationAddress,
      'originAddress': originAddress,
      'polyline': polyline is String
          ? polyline
          : (polyline as List<Map<String, double>>)
          .map((point) => [point['latitude'], point['longitude']])
          .toList(),
      'type': type,
    };
  }
}



 */