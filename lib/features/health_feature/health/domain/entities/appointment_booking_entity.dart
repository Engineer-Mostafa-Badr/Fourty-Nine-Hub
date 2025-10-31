import '../../../../../core/localization/locale_keys.g.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';

class BookedAppointmentEntity {
  final String id;
  final bool bookedPremium;
  final DoctorEntity? doctor;
  final String userId;
  final BookingTypes bookingType;
  final String day;
  final String startTime;
  final String endTime;
  final String bookingId;
  final bool expired;

  BookedAppointmentEntity(
      {required this.id,
      required this.bookedPremium,
      this.doctor,
      required this.userId,
      required this.bookingType,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.bookingId,
      required this.expired});
}

enum BookingTypes { videoCall, clinic, home, emergency }

extension BookingTypesExtension on BookingTypes {
  String get translatedName {
    switch (this) {
      case BookingTypes.videoCall:
        return LocaleKeys.call;
      case BookingTypes.clinic:
        return LocaleKeys.clinicVisit;
      case BookingTypes.home:
        return LocaleKeys.homeVisit;
      case BookingTypes.emergency:
        return LocaleKeys.emergency;
    }
  }
}

extension BookingTypesExtensionString on String {
  BookingTypes get toBookingType {
    final lower = toLowerCase();
    if (lower == 'call' ||
        lower == 'calls' ||
        lower == 'videocall' ||
        lower == 'video_call' ||
        lower == 'video-call') {
      return BookingTypes.videoCall;
    } else if (lower == 'clinic') {
      return BookingTypes.clinic;
    } else if (lower == 'home' ||
        lower == 'homevisit' ||
        lower == 'visithome') {
      return BookingTypes.home;
    } else if (lower == 'emergency') {
      return BookingTypes.emergency;
    }
    return BookingTypes.clinic;
  }
}

BookingTypes getBookingType(value) {
  final str = value.toString().toLowerCase();
  if (str == 'call' ||
      str == 'calls' ||
      str == 'videocall' ||
      str == 'video_call' ||
      str == 'video-call') {
    return BookingTypes.videoCall;
  } else if (str == 'clinic') {
    return BookingTypes.clinic;
  } else if (str == 'home') {
    return BookingTypes.home;
  } else if (str == 'emergency') {
    return BookingTypes.emergency;
  }
  return BookingTypes.clinic;
}
