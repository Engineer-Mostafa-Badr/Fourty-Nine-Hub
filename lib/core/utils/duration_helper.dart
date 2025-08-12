import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/routes/pages.dart';

class DurationHelper {
  String sinceTime({required Duration duration}) {
    return duration.inDays > 0
        ? "${duration.inDays} ${LocaleKeys.days.localize}"
        : duration.inHours > 0
            ? "${duration.inHours} ${LocaleKeys.hours.localize}"
            : "${duration.inMinutes} ${LocaleKeys.minute.localize}";
  }

  String formatTimeAgo(DateTime dateTime) {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      // أقل من ساعة → دقايق
      return currentContext.isArabic
          ? "${difference.inMinutes}دقيقة"
          : "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      // أقل من 24 ساعة → ساعات
      return currentContext.isArabic
          ? "${difference.inHours}ساعة"
          : "${difference.inHours}h";
    } else {
      // أكتر من 24 ساعة → التاريخ
      return "${dateTime.year.toString().padLeft(4, '0')}-"
          "${dateTime.month.toString().padLeft(2, '0')}-"
          "${dateTime.day.toString().padLeft(2, '0')}";
    }
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
