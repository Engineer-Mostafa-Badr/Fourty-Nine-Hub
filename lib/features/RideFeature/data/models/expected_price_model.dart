
import 'dart:developer';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';

class RideExpectedPriceModel extends RideExpectedPriceEntity{
  RideExpectedPriceModel({required super.priceForWomen, required super.priceForTaxi, required super.priceForScooter, required super.priceForCaptain, required super.priceForPremium, required super.priceForIntercity, required super.priceForSUV, required super.lowestFare, required super.highestFare, required super.from, required super.to, required super.startLocation, required super.targetLocation, required super.distance, required super.duration, required super.polyline, required super.comfort, required super.type, required super.autoAccept, required super.nonSmoking, required super.subcategoryModel,});

  //fromJson
  factory RideExpectedPriceModel.fromJson(Map<String, dynamic> json) {

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
    return RideExpectedPriceModel(
      priceForCaptain: (json['priceForCaptain'] ?? 0).toDouble(),
      priceForWomen: (json['priceForWomen'] ?? 0).toDouble(),
      priceForTaxi: (json['priceForTaxi'] ?? 0).toDouble(),
      priceForScooter: (json['priceForScooter'] ?? 0).toDouble(),
      priceForPremium: (json['priceForPremium'] ?? 0).toDouble(),
      priceForIntercity: (json['priceForIntercity'] ?? 0).toDouble(),
      priceForSUV: (json['priceForSUV'] ?? 0).toDouble(),
      lowestFare: (json['lowestFare'] ?? 0).toDouble(),
      highestFare: (json['highestFare'] ?? 0).toDouble(),
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      startLocation: json['startLocation'] == null
          ? []
          : [
        (json['startLocation']['latitude'] ?? 0).toDouble(),
        (json['startLocation']['longitude'] ?? 0).toDouble()
      ],
      targetLocation: json['targetLocation'] == null
          ? []
          : [
        (json['targetLocation']['latitude'] ?? 0).toDouble(),
        (json['targetLocation']['longitude'] ?? 0).toDouble()
      ],
      distance: (json['distance'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 0).toDouble(),
      // polyline: json['polyline'] != null
      //     ? (json['polyline'] as List)
      //     .map((e) =>
      //     (e as List)
      //         .map((p) => (p as num).toDouble())
      //         .toList())
      //     .toList()
      //     : [],
      polyline: parsedPolyline,
      type: json['type'] ?? 'openRouteService',
      comfort: (json['options']?['comfort'] ?? 0).toDouble(),
      autoAccept: (json['options']?['autoAccept'] ?? 0).toDouble(),
      nonSmoking: (json['options']?['nonSmoking'] ?? 0).toDouble(),
      subcategoryModel: (json['subcategory'] as List?)?.map((e) => SubcategoryModel.fromJson(e)).toList() ?? [],
    );
  }
}

class SubcategoryModel {
  final String id;
  final String nameEn;
  final String nameAr;
  final String picture;
  final double price;
  bool isSelected = false;

  SubcategoryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.picture,
    required this.price,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      picture: json['picture'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
