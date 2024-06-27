import '../../../../ads_feature/ads/domain/entities/publisher_entity.dart';
import '../../../doctor_details/domain/entities/appointment_entity.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';

class AppointmentBookingEntity {
  final int id;
  final String status;
  final DateTime createdAt;
  final DoctorEntity doctor;
  final AppointmentEntity appointment;
  final PublisherEntity? user;
  AppointmentBookingEntity({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.doctor,
    required this.appointment,
    this.user,
  });
}
