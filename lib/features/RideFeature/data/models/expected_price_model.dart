import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';

class RideExpectedPriceModel extends RideExpectedPriceEntity{
  RideExpectedPriceModel({required super.priceForWomen, required super.priceForTaxi, required super.priceForScooter, required super.captainPrice, required super.priceForPremium, required super.priceForSUV, required super.nonSmoker, required super.lowestFare, required super.highestFare, required super.from, required super.to, required super.startLocation, required super.targetLocation, required super.distance, required super.duration, required super.calculateB, required super.polyline, required super.comfort, required super.type});

  //fromJson
  factory RideExpectedPriceModel.fromJson(Map<String, dynamic> json) {
    return RideExpectedPriceModel(
      priceForWomen: json['priceForWomen'] ?? 0,
      priceForTaxi: json['priceForTaxi'] ?? 0,
      priceForScooter: json['priceForScooter'] ?? 0,
      captainPrice: json['captainPrice'] ?? 0,
      priceForPremium: json['priceForPremium'] ?? 0,
      priceForSUV: json['priceForSUV'] ?? 0,
      nonSmoker: json['nonSmoker'] ?? 0,
      lowestFare: json['lowestFare'] ?? 0,
      highestFare: json['highestFare'] ?? 0,
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      startLocation: List<double>.from(json['startLocation'] ?? []),
      targetLocation: List<double>.from(json['targetLocation'] ?? []),
      distance: json['distance'] ?? 0,
      duration: (json['duration'] ?? 0).toDouble(),
      calculateB: json['calculate_b'] ?? 0,
      polyline: (json['polyline'] as List? ?? [])
          .map((item) => List<double>.from(item ?? []))
          .toList(),
      comfort: json['comfort'] ?? 0,
      type: json['type'] ?? '',
    );
  }

}