import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

import '../../../../ads_feature/ads/data/models/publisher_model.dart';
import '../../../doctor_details/data/models/appointment_model.dart';

class AppointmentBookingModel extends AppointmentBookingEntity {
  AppointmentBookingModel(
      {required super.id,
      required super.status,
      required super.createdAt,
      required super.doctor,
      required super.type,
      required super.appointment,
      super.user});
  factory AppointmentBookingModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingModel(
        id: json['id'],
        status: json['status'],
        type: json['type'] ?? 'clinic',
        createdAt: DateTime.parse(json['created_at']),
        doctor: DoctorModel.fromJson(json['doctor']),
        appointment: AppointmentModel.fromJson(json['appointment']),
        user: json['user'] == null
            ? null
            : PublisherModel.fromJson(json['user']));
  }
}
