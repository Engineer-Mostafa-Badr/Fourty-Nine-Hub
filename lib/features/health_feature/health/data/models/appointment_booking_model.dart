import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

class BookedUserAppointmentModel extends BookedAppointmentEntity {
  BookedUserAppointmentModel(
      {required super.id,
      required super.bookedPremium,
      required super.doctor,
      required super.userId,
      required super.bookingType,
      required super.day,
      required super.startTime,
      required super.endTime,
      required super.bookingId,
      required super.expired});

  factory BookedUserAppointmentModel.fromJson(Map<String, dynamic> json) {
    return BookedUserAppointmentModel(
      id: json['_id'],
      bookedPremium: json['bookedPremium'],
      doctor: DoctorModel.fromJson(json['doctorId']),
      userId: json['userId'],
      bookingType: (json['appointmentType'] as String).toBookingType,
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      bookingId: json['bookingId'],
      expired: json['expired'],
    );
  }
}
