import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_statistics_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

class DoctorStatisticsModel extends DoctorStatisticsEntity {
  DoctorStatisticsModel(
      {required super.clinic, required super.homeVisit, required super.call});

  factory DoctorStatisticsModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> matchBookingType(BookingTypes bookingType) {
      for (var e in (json['data'] as List)) {
        if (e['appointmentType'] != null &&
            e['appointmentType'] != '' &&
            (e['appointmentType'] as String).toBookingType == bookingType) {
          return e;
        }
      }

      return {};
    }

    final clinic = DoctorStatisticsForBookingTypeModel.fromJson(
        matchBookingType(BookingTypes.clinic));

    final call = DoctorStatisticsForBookingTypeModel.fromJson(
        matchBookingType(BookingTypes.videoCall));

    final home = DoctorStatisticsForBookingTypeModel.fromJson(
        matchBookingType(BookingTypes.home));

    return DoctorStatisticsModel(clinic: clinic, call: call, homeVisit: home);
  }
}

class DoctorStatisticsForBookingTypeModel
    extends DoctorStatisticsForBookingTypeEntity {
  DoctorStatisticsForBookingTypeModel(
      {required super.appointmentsCount, required super.totalEarned});

  factory DoctorStatisticsForBookingTypeModel.fromJson(
      Map<String, dynamic> json) {
    return DoctorStatisticsForBookingTypeModel(
        appointmentsCount: json['count'] ?? 0,
        totalEarned: json['totalEarned'] ?? 0);
  }
}
