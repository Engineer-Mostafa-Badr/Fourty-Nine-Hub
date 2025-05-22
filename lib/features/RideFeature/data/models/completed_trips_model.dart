import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';

class CompletedTripsModel extends CompletedTripsEntity {
  CompletedTripsModel({
    required super.id,
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
    required super.clientFirstName,
    required super.clientLastName,
    required super.clientGender,
  });

  factory CompletedTripsModel.fromJson(Map<String, dynamic> json) {
    return CompletedTripsModel(
      id: json['id'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      categoryPicture: json['categoryPicture'] ?? '',
      categoryNameEn: json['categoryNameEn'] ?? '',
      categoryNameAr: json['categoryNameAr'] ?? '',
      carPicture: (json['carPicture'] as List<dynamic>?)?[0] ?? '',
      address: json['address'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      price: json['price'] ?? 0,
      status: json['status'] ?? '',
      currencyEn: json['currency']?['currencyEn'] ?? 'Unknown',
      currencyAr: json['currency']?['currencyAr'] ?? 'Unknown',
      rating: json['rating']?.toString(),
      car: json['car'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      clientFirstName: json['client']['firstName'] ?? 'Unknown',
      clientLastName: json['client']['lastName'] ?? 'Unknown',
      clientGender: json['client']['gender'] ?? 'male',
    );
  }
}