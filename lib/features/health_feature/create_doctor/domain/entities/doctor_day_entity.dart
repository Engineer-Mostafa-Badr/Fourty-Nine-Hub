import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';

class DoctorDayEntity {
  final WeekDays day;
  bool isAvailable;
  TimeOfDay from;
  TimeOfDay to;

  DoctorDayEntity({
    required this.day,
    this.from = const TimeOfDay(hour: 10, minute: 0),
    this.to = const TimeOfDay(hour: 11, minute: 0),
    this.isAvailable = false,
  });
}
