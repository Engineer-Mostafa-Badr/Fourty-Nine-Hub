import 'package:fourtyninehub/core/enums/ride_services_enum.dart';

class RideThumbnailEntity {
  final String id;
  final String image;
  final String name;
  final RideServicesEnum service;

  RideThumbnailEntity(
      {required this.id,
      required this.image,
      required this.name,
      required this.service});
}
