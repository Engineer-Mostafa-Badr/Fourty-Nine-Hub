import 'package:fourtyninehub/features/health_feature/doctor_details/data/models/doctor_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

class BookedAppointmentModel extends BookedAppointmentEntity {
  BookedAppointmentModel(
      {required super.id,
      required super.bookedPremium,
      required super.doctor,
      required super.userId,
      required super.bookingType,
      required super.day,
      required super.time,
      required super.bookingId,
      required super.expired});

  factory BookedAppointmentModel.fromJson(Map<String, dynamic> json) {
    return BookedAppointmentModel(
      id: json['_id'],
      bookedPremium: json['bookedPremium'],
      doctor: DoctorModel.fromJson(json['doctorId']),
      userId: json['userId'],
      bookingType: (json['appointmentType'] as String).toBookingType,
      day: json['day'],
      time: json['time'],
      bookingId: json['bookingId'],
      expired: json['expired'],
    );
  }
}
