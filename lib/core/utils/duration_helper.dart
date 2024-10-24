import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class DurationHelper {
  String sinceTime({required Duration duration}) {
    return duration.inDays > 0
        ? "${duration.inDays} ${LocaleKeys.days.localize}"
        : duration.inHours > 0
            ? "${duration.inHours} ${LocaleKeys.hours.localize}"
            : "${duration.inMinutes} ${LocaleKeys.minute.localize}";
  }

  String getTimeDifference(DateTime dateTimeString) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTimeString);
    if (difference.inDays > 3) {
      return DateFormat('yyyy-MM-dd').format(dateTimeString);
    } else if (difference.inDays >= 1) {
      return "${difference.inDays} ${LocaleKeys.days.localize}";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} ${LocaleKeys.hours.localize}";
    } else {
      return "${difference.inMinutes} ${LocaleKeys.minute.localize}";
    }
  }

}
