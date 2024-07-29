import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';

class UserDoctorRateModel extends UserDoctorRateEntity{
  UserDoctorRateModel({required super.id, required super.comment, required super.rate, required super.userName});

  factory UserDoctorRateModel.fromJson(Map<String, dynamic> json) {
    return UserDoctorRateModel(
      id: json['_id'],
      comment: json['comment'],
      userName: json['userId']['firstName'],
      rate: (json['rate'] as num).toDouble(),
    );
  }

}