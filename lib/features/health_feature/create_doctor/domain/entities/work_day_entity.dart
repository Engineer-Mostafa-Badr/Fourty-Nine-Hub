import 'package:flutter/material.dart';

class DoctorWorkDayEntity {
  final String day;
  TimeOfDay from;
  TimeOfDay to;

  DoctorWorkDayEntity({
    required this.day,
    this.from = const TimeOfDay(hour: 10, minute: 0),
    this.to = const TimeOfDay(hour: 10, minute: 0),
  });
}
