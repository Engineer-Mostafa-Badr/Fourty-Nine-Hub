import 'package:fourtyninehub/features/health_feature/booking/domain/entities/all_appointment_entity.dart';

class AllAppointmentModel extends AllAppointmentEntity {
  AllAppointmentModel(
      {required super.id,
      required super.doctorId,
      required super.userId,
      required super.firstName,
      required super.lastName,
      required super.gender,
      required super.bookingId,
      required super.appointmentType,
      required super.day,
      required super.startTime,
      required super.endTime,
      required super.dateOfDay,
      required super.status,
      required super.phone,
      required super.additionalNotes,
      required super.isPremium,
      required super.expired,
      required super.createdAt,
      required super.updatedAt});

  //fromJson
  factory AllAppointmentModel.fromJson(Map<String, dynamic> json) {
    return AllAppointmentModel(
      id: json['_id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      userId: json['userId']['_id'] ?? '',
      firstName: json['userId']['firstName'] ?? '',
      lastName: json['userId']['lastName'] ?? '',
      gender: json['userId']['gender'] ?? '',
      bookingId: json['bookingId']['_id'] ?? '',
      appointmentType: json['bookingId']['appointmentType'] ?? '',
      day: json['bookingId']['day'] ?? '',
      startTime: json['bookingId']['startTime'] ?? '',
      endTime: json['bookingId']['endTime'] ?? '',
      dateOfDay: json['bookingId']['DateOfDay'] ?? '',
      status: json['status'] ?? '',
      phone: json['phone'] ?? '',
      additionalNotes: json['additionalNotes'] ?? '',
      isPremium: json['isPremium'] ?? false,
      expired: json['expired'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
