import '../../../../requests_history/domain/entities/address_entity.dart';
import '../../../../ride/RideRequest/domain/entity/driver_review_entity.dart';
import 'appointment_entity.dart';
import 'doctor_detail_entity.dart';

class DoctorEntity {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String bio;
  final num rate;
  final num numberOfReviews;
  final num startPrice;
  final num waitingTime;
  final String image;
  final bool available;
  final List<String> clinicImages;
  final List<String> languages;
  final AddressEntity address;
  final List<AppointmentEntity>? appointments;
  final List<ReviewEntity>? reviews;
  final List<DoctorDetailEntity>? details;

  DoctorEntity(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.bio,
      required this.rate,
      required this.waitingTime,
      required this.available,
      required this.numberOfReviews,
      required this.startPrice,
      required this.image,
      required this.clinicImages,
      required this.languages,
      required this.address,
      required this.appointments,
      required this.reviews,
      required this.details});
}
