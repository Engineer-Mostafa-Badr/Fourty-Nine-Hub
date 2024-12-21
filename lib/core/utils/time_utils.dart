import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class TimeUtils {
  /// Calculates the duration since the provided [createdAt] time.
  static Duration calculateDuration(DateTime? createdAt) {
    return createdAt != null ? DateTime.now().difference(createdAt) : Duration.zero;
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

}
