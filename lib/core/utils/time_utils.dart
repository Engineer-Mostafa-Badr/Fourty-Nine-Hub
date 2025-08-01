import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/routes/pages.dart';

class TimeUtils {
  /// Calculates the duration since the provided [createdAt] time.
  static Duration calculateDuration(DateTime? createdAt) {
    return createdAt != null
        ? DateTime.now().difference(createdAt)
        : Duration.zero;
  }

  static String formatTimeAgo(String timestamp, bool isArabic) {
    final now = DateTime.now().toUtc();
    final dateTime = DateTime.parse(timestamp).toUtc();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return isArabic ? 'الآن' : 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return isArabic ? '$minutes دقيقة' : '$minutes m';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return isArabic ? '$hours ساعة' : '$hours h';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return isArabic ? '$days يوم' : '$days d';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return isArabic ? '$weeks أسبوع' : '$weeks w';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return isArabic ? '$months شهر' : '$months mo';
    } else {
      final years = (difference.inDays / 365).floor();
      return isArabic ? '$years سنة' : '$years y';
    }
  }

  /// Returns a human-readable time difference (e.g., "3 h", "2 days", or "15 October 2023")
  static String getSinceTime(DateTime? createdAt) {
    if (createdAt == null) return "Unknown";
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 10) {
      return "${createdAt.day} ${_getMonthName(createdAt.month)} ${createdAt.year}";
    } else if (difference.inDays >= 1) {
      return "${difference.inDays} ${LocaleKeys.d.localize}${difference.inDays > 1 ? '' : ''}";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} ${LocaleKeys.h.localize}";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} ${LocaleKeys.m.localize}";
    } else {
      return "just now";
    }
  }

  static String _getMonthName(int month, {DateTime? date}) {
    final monthNames = [
      LocaleKeys.January.tr(),
      LocaleKeys.February.tr(),
      LocaleKeys.March.tr(),
      LocaleKeys.April.tr(),
      LocaleKeys.May.tr(),
      LocaleKeys.June.tr(),
      LocaleKeys.July.tr(),
      LocaleKeys.August.tr(),
      LocaleKeys.September.tr(),
      LocaleKeys.October.tr(),
      LocaleKeys.November.tr(),
      LocaleKeys.December.tr(),
    ];

    // If the month is invalid, return the full date in "dd MMMM yyyy" format
    if (month < 1 || month > 12) {
      if (date != null) {
        final day = date.day;
        final year = date.year;
        final localizedMonth = monthNames[date.month - 1];
        return "$day $localizedMonth $year";
      }
      return ''; // Fallback for invalid date
    }

    return monthNames[month - 1];
  }



  static String getRelativeTime(String utcDateTimeString) {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    // Parse the UTC datetime string
    DateTime utcDateTime = DateTime.parse(utcDateTimeString);

    // Get the current time
    DateTime now = DateTime.now().toUtc();

    // Calculate the difference
    Duration difference = now.difference(utcDateTime);

    // If less than 1 minute
    if (difference.inMinutes < 1) {
      int seconds = difference.inSeconds;
      return '${FormatNumbers().convertNumberToLocalizedString(seconds.toString(), isArabic: currentContext.isArabic)} ${currentContext.isArabic?"ثانية":"Sec"}';
    }
    // If 1 minute or more
    else {
      int minutes = difference.inMinutes;
      return '${FormatNumbers().convertNumberToLocalizedString(minutes.toString(), isArabic: currentContext.isArabic)} ${currentContext.isArabic?"دقيقة":"Min"}';
    }
  }
}
