import 'package:fourtyninehub/features/RideFeature/data/models/helpers/currency.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/past_trip_entity.dart';

class PastTripModel extends PastTripEntity {
  PastTripModel({
    required super.id,
    required super.categoryPicture,
    required super.categoryNameEn,
    required super.categoryNameAr,
    required super.to,
    required super.from,
    required super.startCoordinates,
    required super.targetCoordinates,
    required super.time,
    required super.createdAt,
    required super.price,
    required super.status,
    required super.car,
    required super.currency,
    required super.driverFirstName,
    required super.rating,
  });

  factory PastTripModel.fromJson(Map<String, dynamic> json) {
    return PastTripModel(
      id: json['id'],
      categoryPicture: json['categoryPicture'],
      categoryNameEn: json['categoryNameEn'],
      categoryNameAr: json['categoryNameAr'],
      to: json['to'],
      from: json['from'],
      startCoordinates: json['startCoordinates'] != null ? List<double>.from(json['startCoordinates']) : null,
      targetCoordinates: json['targetCoordinates'] != null ? List<double>.from(json['targetCoordinates']) : null,
      time: json['time'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      price: json['price']?.toDouble(),
      status: json['status'],
      car: json['car'],
      currency: json['currency'] != null ? Currency.fromJson(json['currency']) : null,
      driverFirstName: json['driverFirstName'],
      rating: json['rating']?.toDouble(),
    );
  }
}
