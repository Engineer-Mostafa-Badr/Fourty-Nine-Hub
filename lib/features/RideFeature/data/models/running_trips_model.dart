import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';

class RunningTripsModel extends RunningTripsEntity {
  RunningTripsModel({required super.id,
    required super.to,
    required super.from,
    required super.categoryPicture,
    required super.categoryNameEn,
    required super.categoryNameAr,
    required super.carPicture,
    required super.address,
    required super.createdAt,
    required super.price,
    required super.status,
    required super.currencyEn,
    required super.currencyAr,
    required super.rating,
    required super.car,
    required super.gender,
  });

  factory RunningTripsModel.fromJson(Map<String, dynamic> json) {
    return RunningTripsModel(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      categoryPicture: json['categoryPicture'],
      categoryNameEn: json['categoryNameEn'],
      categoryNameAr: json['categoryNameAr'],
      carPicture: json['carPicture'],
      address: json['address'],
      createdAt: DateTime.parse(json['createdAt']),
      price: json['price'],
      status: json['status'],
      currencyEn: json['currency']['currencyEn'],
      currencyAr: json['currency']['currencyAr'],
      rating: json['rating'],
      car: json['car'],
      gender: json['gender'],
    );
  }
}