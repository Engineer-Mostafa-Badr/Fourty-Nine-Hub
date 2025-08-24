import 'package:intl/intl.dart';

class DateTimeHelper {

  // Format last message time with Arabic/English support
  static String formatLastMessageTime(DateTime? dateTime, bool isArabic) {
    if (dateTime == null) return isArabic ? 'غير محدد' : 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Same day - show time only
    if (messageDate == today) {
      return _formatTime(dateTime, isArabic);
    }
    // Yesterday
    else if (messageDate == yesterday) {
      return isArabic ? 'أمس' : 'Yesterday';
    }
    // Within this week - show day name
    else if (difference.inDays < 7) {
      return _formatDayName(dateTime, isArabic);
    }
    // Within this year - show date without year
    else if (dateTime.year == now.year) {
      return _formatDateWithoutYear(dateTime, isArabic);
    }
    // Different year - show full date
    else {
      return _formatFullDate(dateTime, isArabic);
    }
  }

  // Format time (12:30 PM / ١٢:٣٠ م)
  static String _formatTime(DateTime dateTime, bool isArabic) {
    if (isArabic) {
      final hour = dateTime.hour;
      final minute = dateTime.minute;
      final period = hour >= 12 ? 'م' : 'ص';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${_toArabicNumbers(hour12.toString().padLeft(2, '0'))}:${_toArabicNumbers(minute.toString().padLeft(2, '0'))} $period';
    } else {
      // Force English locale to avoid device locale interference
      return DateFormat('h:mm a', 'en_US').format(dateTime);
    }
  }

  // Format day name (Monday / الاثنين)
  static String _formatDayName(DateTime dateTime, bool isArabic) {
    if (isArabic) {
      const arabicDays = [
        'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس',
        'الجمعة', 'السبت', 'الأحد'
      ];
      return arabicDays[dateTime.weekday - 1];
    } else {
      return DateFormat('EEEE', 'en_US').format(dateTime);
    }
  }

  // Format date without year (Dec 25 / ٢٥ ديسمبر)
  static String _formatDateWithoutYear(DateTime dateTime, bool isArabic) {
    if (isArabic) {
      const arabicMonths = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return '${_toArabicNumbers(dateTime.day.toString())} ${arabicMonths[dateTime.month - 1]}';
    } else {
      return DateFormat('MMM d', 'en_US').format(dateTime);
    }
  }

  // Format full date (Dec 25, 2023 / ٢٥ ديسمبر ٢٠٢٣)
  static String _formatFullDate(DateTime dateTime, bool isArabic) {
    if (isArabic) {
      const arabicMonths = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return '${_toArabicNumbers(dateTime.day.toString())} ${arabicMonths[dateTime.month - 1]} ${_toArabicNumbers(dateTime.year.toString())}';
    } else {
      return DateFormat('MMM d, y', 'en_US').format(dateTime);
    }
  }

  // Convert English numbers to Arabic numbers
  static String _toArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = input;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}

// Extension for easy access
extension DateTimeFormatting on DateTime {
  String formatForLastMessage(bool isArabic) {
    return DateTimeHelper.formatLastMessageTime(this, isArabic);
  }
}