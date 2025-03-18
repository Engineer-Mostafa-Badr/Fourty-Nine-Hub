import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/car_type_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/user_profile_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/rider_entity.dart';

class RiderDashboardModel extends RiderEntity {
  const RiderDashboardModel({
    required super.id,
    required UserModel super.userId,
    required CarTypeModel super.carTypeId,
    required super.phone,
    required super.carModel,
  });

  factory RiderDashboardModel.fromJson(Map<String, dynamic> json) {
    return RiderDashboardModel(
      id: json['_id'],
      userId: UserModel.fromJson(json['userId']),
      carTypeId: CarTypeModel.fromJson(json['carTypeId']),
      phone: json['phone'],
      carModel: json['carModel'],
    );
  }
}
