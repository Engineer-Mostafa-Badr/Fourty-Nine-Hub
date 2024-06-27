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


enum BookingTypes { online, clinic }

extension BookingTypesExtension  on  BookingTypes{
  String get value{
    switch(this){
      case BookingTypes.online:
      return 'online';
      case BookingTypes.clinic:
      return 'clinic';
    }
  }
  String get title{
    switch(this){
      case BookingTypes.online:
      return 'Online';
      case BookingTypes.clinic:
      return 'Clinic';
    }
  }
}
BookingTypes getBookingType(value) {
  switch (value) {
    case 'online':
    return BookingTypes.online;
    case 'clinic':
    return BookingTypes.clinic;
  }
  return BookingTypes.clinic;
}
