import 'package:fourtyninehub/core/enums/gender_type.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

class DoctorAppointmentEntity {
  final String firstName;
  final String lastName;
  final String? image;
  final WeekDays day;
  final String time;
  final BookingTypes type;
final String additionalNotes ;
final GenderType gender;

  DoctorAppointmentEntity( {
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.additionalNotes,
    this.image,
    required this.day,
    required this.time,
    required this.type,
  });

  String get fullName => '$firstName $lastName';
}
