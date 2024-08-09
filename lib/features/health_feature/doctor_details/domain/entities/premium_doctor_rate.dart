import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_rate.dart';

class PremiumDoctorRateEntity extends DoctorRateEntity {
  final String firstName;
  final String lastName;
  final String phone;
  PremiumDoctorRateEntity(
      {required super.id,
      required super.comment,
      required super.rate,
      required this.firstName,
      required this.lastName,
      required this.phone});
}
