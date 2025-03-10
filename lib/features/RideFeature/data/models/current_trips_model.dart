import 'package:fourtyninehub/features/RideFeature/data/models/helpers/currency.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/current_trip_entity.dart';

class CurrentTripModel extends CurrentTripEntity {
  CurrentTripModel({
    required super.id,
    required super.categoryPicture,
    required super.categoryNameEn,
    required super.categoryNameAr,
    required super.to,
    required super.from,
    required super.time,
    required super.createdAt,
    required super.price,
    required super.status,
    required super.car,
    required super.currency,
    required super.driverFirstName,
  });

  factory CurrentTripModel.fromJson(Map<String, dynamic> json) {
    return CurrentTripModel(
      id: json['id'],
      categoryPicture: json['categoryPicture'],
      categoryNameEn: json['categoryNameEn'],
      categoryNameAr: json['categoryNameAr'],
      to: json['to'],
      from: json['from'],
      time: json['time'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      price: json['price']?.toDouble(),
      status: json['status'],
      car: json['car'],
      currency: json['currency'] != null ? Currency.fromJson(json['currency']) : null,
      driverFirstName: json['driverFirstName'],
    );
  }
}