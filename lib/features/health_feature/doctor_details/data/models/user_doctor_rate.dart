import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';

class UserDoctorRateModel extends UserDoctorRateEntity {
  UserDoctorRateModel(
      {required super.id,
      required super.comment,
      required super.rate,
      super.phone,
      super.userId,
      super.createdAt,
      super.gender,
      super.openCall,
      required super.userName});

  factory UserDoctorRateModel.fromJson(Map<String, dynamic> json) {
    return UserDoctorRateModel(
      id: json['_id'] ?? '',
      openCall: json['openCall'] ?? false,
      comment: json['comment'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userName: json['userId'] != null ? json['userId']['firstName'] : '',
      userId: json['userId'] != null ? json['userId']['_id'] : '',
      gender: json['userId'] != null ? json['userId']['gender'] : '',
      rate: (json['rate'] as num).toDouble(),
    );
  }
}
