import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel(
      {required super.id,
      required super.day,
      required super.time,
      required super.status});
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      day: json['day'],
      time: json['time'],
      status: (json['status'] as String).toAppointmentStatus,
    );
  }
}
