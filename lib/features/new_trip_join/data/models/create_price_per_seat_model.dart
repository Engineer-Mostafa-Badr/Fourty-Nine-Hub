import 'dart:developer';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';

class CreatePricePerSeatModel extends CreatePricePerSeatEntity{
  CreatePricePerSeatModel({required super.basePricePerSeatWithoutFeatures, required super.finalPricePerSeat, required super.totalDistance, required super.originAddress, required super.destinationAddress, required super.polyline,super.comfortFee,super.ladyDriverFee,super.ladyPassengerFee});

  //fromJson
  factory CreatePricePerSeatModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> parsedPolyline = [];

    if (json['polyline'] != null) {
      if (json['polyline'] is String) {
        // Decode the encoded polyline string
        log("Polyline: ${json['polyline']}");
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(json['polyline']);
        log("Decoded polyline: $decoded");
        parsedPolyline = decoded.map((e) => [e.longitude, e.latitude]).toList();
        log("Parsed polyline: $parsedPolyline");
      } else if (json['polyline'] is List) {
        // Use the list directly
        parsedPolyline = (json['polyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }
    return CreatePricePerSeatModel(
      basePricePerSeatWithoutFeatures: json['basePricePerSeatWithoutFeatures'],
      finalPricePerSeat: json['finalPricePerSeat'],
      totalDistance: json['totalDistance'],
      originAddress: json['originAddress'],
      destinationAddress: json['destinationAddress'],
      polyline: parsedPolyline,
      comfortFee: json['appliedFeatures']!=null?json['appliedFeatures']['comfortFee']:null,
      ladyPassengerFee: json['appliedFeatures']!=null?json['appliedFeatures']['ladyPassengerFee']:null,
      ladyDriverFee: json['appliedFeatures']!=null?json['appliedFeatures']['ladyDriverFee']:null,
    );
  }
}