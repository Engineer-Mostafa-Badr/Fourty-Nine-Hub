import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_rate.dart';

class UserDoctorRateEntity extends DoctorRateEntity {
  final String userName;
  UserDoctorRateEntity(
      {required super.id,
      required super.comment,
      required super.rate,
      required this.userName});
}
