import 'package:flutter/material.dart';

class DoctorDayAvailabilityEntity {
  final String day;
  TimeOfDay from;
  TimeOfDay to;
  bool isAvailable;

  DoctorDayAvailabilityEntity(
      {required this.day,
      this.from = const TimeOfDay(hour: 10, minute: 0),
      this.to = const TimeOfDay(hour: 10, minute: 0),
      this.isAvailable = false});
}
