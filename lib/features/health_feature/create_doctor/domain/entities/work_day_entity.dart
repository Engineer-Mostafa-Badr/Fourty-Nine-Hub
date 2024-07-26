import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';

class DoctorWorkDayEntity {
  final WeekDays day;
  TimeOfDay from;
  TimeOfDay to;

  DoctorWorkDayEntity({
    required this.day,
    this.from = const TimeOfDay(hour: 10, minute: 0),
    this.to = const TimeOfDay(hour: 10, minute: 0),
  });
}
