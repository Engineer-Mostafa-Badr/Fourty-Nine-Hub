import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import 'appointment_entity.dart';

class DoctorEntity {
  final String id;
  final String lastName;
  final String firstName;
  final SubCategoryEntity subCategory;
  final String image;
  final String phone;
  final String email;
  final DoctorAddressEntity address;
  final bool clinic;
  final bool calls;
  final bool visitHome;
  final String clinicPrice;
  final String detectionPeriodClinic;
  final String detectionPeriodCalls;
  final String detectionPeriodvisitHome;
  final String callsPrice;
  final String visitHomePrice;
  final String _waitingTime;
  final bool isActive;
  final bool isPremium;
  final String description;
  final int rating;
  final String createdAt;
  final String updatedAt;
  final List<AppointmentEntity> appointments;
  final List<DoctorDayEntity> clinicDays;
  final List<DoctorDayEntity> callDays;
  final List<DoctorDayEntity> homeVisitDays;

  DoctorEntity({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.subCategory,
    required this.image,
    required this.phone,
    required this.email,
    required this.address,
    required this.clinic,
    required this.calls,
    required this.visitHome,
    required this.clinicPrice,
    required this.detectionPeriodClinic,
    required this.detectionPeriodCalls,
    required this.detectionPeriodvisitHome,
    required this.callsPrice,
    required this.visitHomePrice,
    required String waitingTime,
    required this.isActive,
    required this.isPremium,
    required this.description,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.appointments,
    required this.clinicDays,
    required this.callDays,
    required this.homeVisitDays,
  }) : _waitingTime = waitingTime;

  String get priceToShow {
    String price = '';
    final bookingType =
        serviceLocator<HealthSharedData>().doctorSearchParams.bookingType;
    if (bookingType == BookingTypes.call) {
      price = callsPrice;
    } else if (bookingType == BookingTypes.clinic) {
      price = clinicPrice;
    } else {
      price = visitHomePrice;
    }
    price = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return price;
  }

  String get waitingTime => _waitingTime.replaceAll(RegExp(r'[^0-9]'), '');
  String get fullName => '$firstName $lastName';
}
