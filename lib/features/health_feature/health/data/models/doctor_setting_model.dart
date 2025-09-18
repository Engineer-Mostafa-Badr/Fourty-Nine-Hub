import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_setting_entity.dart';

class DoctorSettingModel extends DoctorSettingEntity {
  DoctorSettingModel({required super.isApproved, required super.isDoctor});

  //fromJson
  factory DoctorSettingModel.fromJson(Map<String, dynamic> json) {
    return DoctorSettingModel(
      isApproved: json['isApproved'],
      isDoctor: json['isDoctor'],
    );
  }
}