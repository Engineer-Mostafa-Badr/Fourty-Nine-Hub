import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayHelper on TimeOfDay {
  String get display =>
      DateFormat('hh:mm a').format(DateTime(1, 1, 1, hour, minute));

  bool isBefore(TimeOfDay other) =>
      ((hour < other.hour) || (hour == other.hour && minute < other.minute));

  bool isEqual(TimeOfDay other) =>
      (hour == other.hour) && (minute == other.minute);

  bool isAfter(TimeOfDay other) =>
      ((hour > other.hour) || (hour == other.hour && minute > other.minute));
}
