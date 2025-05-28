import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_details_entity.dart';

import 'location_model.dart';

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    required super.id,
    required super.price,
    required super.status,
    required super.isPremium,
    required super.passengers,
    required LocationModel super.startLocation,
    required LocationModel super.targetLocation, required super.pickupTime, required super.note, required super.createdAt,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id']??'',
      price: json['price']??0,
      status: json['status']??'',
      pickupTime: json['pickupTime']??'',
      isPremium: json['isPremium']??false,
      passengers: json['passengers']??0,
      note: json['note']??'',
      startLocation: LocationModel.fromJson(json['startLocation']),
      targetLocation: LocationModel.fromJson(json['targetLocation']),
      createdAt: json['createdAt'],
    );
  }
}