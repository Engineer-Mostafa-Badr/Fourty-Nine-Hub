import 'package:intl/intl.dart';

class DateHelper {
  String getDate({
    required DateTime date,
  }) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String getDayName({
    required DateTime date,
  }) {
    final formatter = DateFormat('EEEE');
    return formatter.format(date);
  }

  String getHourFormat({
    required DateTime date,
  }) {
    final formatter = DateFormat('hh:mm aa');
    return formatter.format(date);
  }
}
