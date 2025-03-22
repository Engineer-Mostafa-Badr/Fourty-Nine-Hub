import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/driver_details_entity.dart';

class DriverDetailsModel extends DriverDetailsEntity {
  const DriverDetailsModel({
    required super.id,
    required super.subscriptionType,
    required super.isActive,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'],
      subscriptionType: json['subscriptionType'],
      isActive: json['isActive'],
    );
  }
}