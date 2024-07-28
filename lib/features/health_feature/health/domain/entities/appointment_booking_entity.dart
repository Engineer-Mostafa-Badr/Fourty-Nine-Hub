import 'package:fourtyninehub/res/strings/labels.dart';

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
  final String type;
  BookingTypes get bookingType => getBookingType(type);
  AppointmentBookingEntity({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.doctor,
    required this.type,
    required this.appointment,
    this.user,
  });
}

enum BookingTypes { call, clinic, home, emergency }

extension BookingTypesExtension on BookingTypes {
  String get translatedName {
    switch (this) {
      case BookingTypes.call:
        return Labels.call;
      case BookingTypes.clinic:
        return Labels.clinicVist;
      case BookingTypes.home:
        return Labels.homeVist;
      case BookingTypes.emergency:
        return Labels.emergency;
    }
  }
}

BookingTypes getBookingType(value) {
  switch (value.toString()) {
    case 'call':
      return BookingTypes.call;
    case 'clinic':
      return BookingTypes.clinic;
    case 'home':
      return BookingTypes.home;
    case 'emergency':
      return BookingTypes.emergency;
  }
  return BookingTypes.clinic;
}
