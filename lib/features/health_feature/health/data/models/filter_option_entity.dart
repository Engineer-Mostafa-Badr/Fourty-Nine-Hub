import 'package:fourtyninehub/core/enums/doctor_services.dart';

class HealthFilterOptionModel {
  final DoctorServices service;
  final String image;
  final String route;

  const HealthFilterOptionModel({
    required this.route,
    required this.service,
    required this.image,
  });
}
