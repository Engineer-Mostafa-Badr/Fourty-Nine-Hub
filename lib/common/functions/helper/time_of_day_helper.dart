import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayHelper on TimeOfDay {
  String get formattedIn12Hour =>
      DateFormat('hh:mm a').format(DateTime(1, 1, 1, hour, minute));

  bool isBefore(TimeOfDay other) =>
      ((hour < other.hour) || (hour == other.hour && minute < other.minute));

  bool isEqual(TimeOfDay other) =>
      (hour == other.hour) && (minute == other.minute);

  bool isAfter(TimeOfDay other) =>
      ((hour > other.hour) || (hour == other.hour && minute > other.minute));
}

extension TimeOfDayExtensionOnString on String {
  TimeOfDay get toTimeOfDay {
    bool isPM = toLowerCase().contains('pm');
    int h = 0;
    int m = 0;
    if (contains(':')) {
      h = int.parse(split(':').first);
      m = int.parse(split(':').last.replaceAll(RegExp(r'[^0-9]'), ''));
    } else {
      h = int.parse(replaceAll(RegExp(r'[^0-9]'), ''));
    }
    if (isPM) {
      if (h == 12) {
        h = 0;
      } else {
        h += 12;
      }
    }
    return TimeOfDay(hour: h, minute: m);
  }
}
