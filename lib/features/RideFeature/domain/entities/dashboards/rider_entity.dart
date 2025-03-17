import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/car_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/user_entity.dart';

class RiderEntity extends Equatable {
  final String id;
  final UserEntity userId;
  final CarTypeEntity carTypeId;
  final String phone;
  final String carModel;

  const RiderEntity({
    required this.id,
    required this.userId,
    required this.carTypeId,
    required this.phone,
    required this.carModel,
  });

  @override
  List<Object?> get props => [id, userId, carTypeId, phone, carModel];
}
