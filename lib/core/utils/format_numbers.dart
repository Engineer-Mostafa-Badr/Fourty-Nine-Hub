import 'package:easy_localization/easy_localization.dart';

class FormatNumbers{
  String formatNumber(num number) {
    if (number >= 1000 && number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}

class FormatDate{
  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString).toLocal();
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime tomorrow = today.add(Duration(days: 1));

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return "Today";
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return "Yesterday";
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return "Tomorrow";
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

}