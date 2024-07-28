import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';

class HealthBookingFilterModel {
  final BookingTypes bookingType;
  final String image;
  final String route;

  const HealthBookingFilterModel({
    required this.route,
    required this.bookingType,
    required this.image,
  });
}
