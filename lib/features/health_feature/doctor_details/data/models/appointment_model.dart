import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel(
      {required super.id,
      required super.day,
      required super.appointmentType,
      required super.startTime,
      required super.dateOfDay,
      required super.endTime,
      required super.isExpired,
      required super.status});
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'] ?? '',
      day: json['day'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      dateOfDay: json['DateOfDay'] ?? '',
      isExpired: json['isExpired'] ?? false,
      appointmentType: json['appointmentType'] ?? '',
      status: ((json['status'] ?? '') as String).toAppointmentStatus,
    );
  }
}
