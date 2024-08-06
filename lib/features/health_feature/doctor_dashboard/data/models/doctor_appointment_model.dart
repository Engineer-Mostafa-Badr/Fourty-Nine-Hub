import 'package:fourtyninehub/core/enums/gender_type.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

class DoctorAppointmentModel extends DoctorAppointmentEntity {
  DoctorAppointmentModel({
    required super.firstName,
    required super.lastName,
    required super.day,
    required super.time,
    required super.type,
    super.image,
    required super.gender,
    required super.additionalNotes,
  });

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentModel(
      firstName: json['userId']['firstName'] ?? '',
      lastName: json['userId']['lastName'] ?? '',
      day:
          ((json['day'] ?? json['bookingId']['day'] ?? '') as String).toWeekDay,
      time: json['time'] ?? json['bookingId']['time'] ?? '',
      type: ((json['appointmentType'] ??
              json['bookingId']['appointmentType'] ??
              '') as String)
          .toBookingType,
      image: json['userId']['USER_PROFILE']['profilePictureKey']['mediaKey'] ??
          UIConst.profilePlaceHolder,
      gender: ((json['gender'] ?? '') as String).toGenderType,
      additionalNotes: json['additionalNotes'] ?? '',
    );
  }
}
