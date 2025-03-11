import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';

class RunningTripsModel extends RunningTripsEntity {
  RunningTripsModel({
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

  factory RunningTripsModel.fromJson(Map<String, dynamic> json) {
    return RunningTripsModel(
      id: json['id'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      categoryPicture: json['categoryPicture'] ?? '',
      categoryNameEn: json['categoryNameEn'] ?? '',
      categoryNameAr: json['categoryNameAr'] ?? '',
      carPicture: json['carPicture'] ?? '', // Handle null as empty string
      address: json['address'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(), // Fallback to current time
      price: json['price'] ?? 0,
      status: json['status'] ?? '',
      currencyEn: json['currency']?['currencyEn'] ?? 'Unknown',
      currencyAr: json['currency']?['currencyAr'] ?? 'Unknown',
      rating: json['rating']?.toString(), // Convert double to string safely
      car: json['car'] ?? 'Unknown', // Provide fallback values
      gender: json['gender'] ?? 'Unknown', // Handle null gender
      clientFirstName: json['client']['firstName'] ?? 'Unknown',
      clientLastName: json['client']['lastName'] ?? 'Unknown',
      clientGender: json['client']['gender'] ?? 'male',
    );
  }
}
