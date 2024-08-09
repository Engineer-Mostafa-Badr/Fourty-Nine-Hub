import 'package:fourtyninehub/res/strings/labels.dart';

import '../../../doctor_details/domain/entities/doctor_entity.dart';

class BookedAppointmentEntity {
  final String id;
  final bool bookedPremium;
  final DoctorEntity doctor;
  final String userId;
  final BookingTypes bookingType;
  final String day;
  final String time;
  final String bookingId;
  final bool expired;

  BookedAppointmentEntity(
      {required this.id,
      required this.bookedPremium,
      required this.doctor,
      required this.userId,
      required this.bookingType,
      required this.day,
      required this.time,
      required this.bookingId,
      required this.expired});
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

extension BookingTypesExtensionString on String {
  BookingTypes get toBookingType {
    switch (toLowerCase()) {
      case 'call' || 'calls':
        return BookingTypes.call;
      case 'clinic':
        return BookingTypes.clinic;
      case 'home' || 'homevisit' || 'visithome':
        return BookingTypes.home;
      case 'emergency':
        return BookingTypes.emergency;
      default:
        return BookingTypes.clinic;
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
