import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_rate.dart';

class DoctorRateModel extends DoctorRateEntity {
  DoctorRateModel(
      {required super.id, required super.comment, required super.rate});

  factory DoctorRateModel.fromJson(Map<String, dynamic> json) {
    return DoctorRateModel(
      id: json['_id'],
      comment: json['comment'],
      rate: json['rate'],
    );
  }
}
