import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';

class EarnedMoneyModel extends EarnedMoneyEntity {
  EarnedMoneyModel({required super.count, required super.appointmentType, required super.totalEarned});

  factory EarnedMoneyModel.fromJson(Map<String, dynamic> json) {
    return EarnedMoneyModel(
      count: json['count']??0,
      appointmentType: json['appointmentType']??'',
      totalEarned: json['totalEarned']??0,);
  }

}
