import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_rate.dart';

class UserDoctorRateEntity extends DoctorRateEntity {
  final String userName;
  final String? userId;
  final String? phone;
  final String? gender;
  final bool? openCall;
  final String? createdAt;
  UserDoctorRateEntity(
      {required super.id,
      required super.comment,
        this.phone,this.userId, this.gender,this.createdAt, this.openCall,
      required super.rate,
      required this.userName});
}
