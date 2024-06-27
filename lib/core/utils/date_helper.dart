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

  bool isSameDate(DateTime date1, DateTime date2) {
    
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
