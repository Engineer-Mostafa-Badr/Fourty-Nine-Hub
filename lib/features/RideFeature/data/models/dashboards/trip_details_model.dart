import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_details_entity.dart';

import 'location_model.dart';

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    required super.id,
    required super.price,
    required super.status,
    required super.distance,
    required super.duration,
    required super.isPremium,
    required super.autoAccept,
    required super.passengers,
    required super.freeTripForDriver,
    required super.paymentMethod,
    required LocationModel super.startLocation,
    required LocationModel super.targetLocation,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id'],
      price: json['price'].toDouble(),
      status: json['status'],
      distance: json['distance'],
      duration: json['duration'],
      isPremium: json['isPremium'],
      autoAccept: json['autoAccept'],
      passengers: json['passengers'],
      freeTripForDriver: json['freeTripForDriver'],
      paymentMethod: json['paymentMethod'],
      startLocation: LocationModel.fromJson(json['startLocation']),
      targetLocation: LocationModel.fromJson(json['targetLocation']),
    );
  }
}