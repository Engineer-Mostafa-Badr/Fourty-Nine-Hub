import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

class FormatNumbers {
  // String formatNumber(num number, {int decimals = 1}) {
  //   if (number >= 1000 && number < 1000000) {
  //     return '${(number / 1000).toStringAsFixed(decimals)}K';
  //   } else if (number >= 1000000 && number < 1000000000) {
  //     return '${(number / 1000000).toStringAsFixed(decimals)}M';
  //   } else if (number >= 1000000000) {
  //     return '${(number / 1000000000).toStringAsFixed(decimals)}B';
  //   } else {
  //     return number.toStringAsFixed(0);
  //   }
  // }

  String formatNumber(num number,
      {int decimals = 1,
      bool useArabicNumerals = false,
      bool roundDown = false}) {
    String formattedNumber;

    if (number >= 1000 && number < 1000000) {
      double dividedValue = number / 1000;
      formattedNumber = roundDown
          ? '${_roundDown(dividedValue, decimals)} K'
          : '${dividedValue.toStringAsFixed(decimals)} K';
    } else if (number >= 1000000 && number < 1000000000) {
      double dividedValue = number / 1000000;
      formattedNumber = roundDown
          ? '${_roundDown(dividedValue, decimals)} M'
          : '${dividedValue.toStringAsFixed(decimals)} M';
    } else if (number >= 1000000000) {
      double dividedValue = number / 1000000000;
      formattedNumber = roundDown
          ? '${_roundDown(dividedValue, decimals)} B'
          : '${dividedValue.toStringAsFixed(decimals)} B';
    } else {
      formattedNumber = number.floor().toString();
    }

    if (useArabicNumerals) {
      return convertToArabicNumerals(formattedNumber);
    }
    return formattedNumber;
  }

  // دالة مساعدة للتقريب إلى الأدنى
  int _roundDown(double value, int decimals) {
    final factor = pow(10, decimals).toDouble();
    return ((value * factor).floorToDouble() / factor).toInt();
  }

  String convertNumberToLocalizedString(String number,
      {required bool isArabic}) {
    return isArabic
        ? convertToArabicNumerals(number.toString())
        : number.toString();
  }

  String convertToArabicNumerals(String input) {
    const Map<String, String> numeralsMap = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
      '.': '.',
      ',': ',',
      'K': 'ألف ',
      'M': 'مليون ',
      'B': 'مليار ',
    };

    return input.split('').map((char) => numeralsMap[char] ?? char).join('');
  }

  String formatNumberByComma(
    String? balance, {
    bool isArabic = false,
  }) {
    if (balance == null || balance.isEmpty) {
      return "N/A";
    }

    try {
      final number = num.parse(balance);
      // final isArabic = context.isArabic; // تأكد أن هذه القيمة صحيحة

      // تنسيق الرقم مع فواصل الآلاف
      String formattedNumber = _formatWithCommas(number.floor());

      // إذا كانت اللغة عربية، تحويل الأرقام إلى العربية
      if (isArabic) {
        formattedNumber = convertToArabicNumerals(formattedNumber);
      }

      return formattedNumber;
    } catch (e) {
      print("Error parsing number: $e");
      return "N/A";
    }
  }

  /// دالة لإضافة فواصل الآلاف يدويًا (مثل 1,000,000)
  String _formatWithCommas(num number) {
    String numberStr = number.toString();
    final length = numberStr.length;

    if (length <= 3) {
      return numberStr;
    }

    String result = '';
    int count = 0;

    for (int i = length - 1; i >= 0; i--) {
      result = numberStr[i] + result;
      count++;

      if (count % 3 == 0 && i != 0) {
        result = ',$result'; // إضافة فاصلة كل 3 أرقام
      }
    }

    return result;
  }
}

class FormatDate {
  String formatDate(String dateString, {bool isArabic = false}) {
    DateTime date = DateTime.parse(dateString).toLocal();
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime tomorrow = today.add(Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return isArabic ? "اليوم" : "Today";
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return isArabic ? "الأمس" : "Yesterday";
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return isArabic ? "غداً" : "Tomorrow";
    } else {
      return isArabic
          ? DateFormat('yyyy/MM/dd', 'ar').format(date)
          : DateFormat('yyyy/MM/dd', 'en').format(date);
    }

    //   DateTime date = DateTime.parse(dateString).toLocal();
    //   DateTime now = DateTime.now();

    //   DateTime today = DateTime(now.year, now.month, now.day);
    //   DateTime yesterday = today.subtract(Duration(days: 1));
    //   DateTime tomorrow = today.add(Duration(days: 1));

    //   if (date.year == today.year &&
    //       date.month == today.month &&
    //       date.day == today.day) {
    //     return "Today";
    //   } else if (date.year == yesterday.year &&
    //       date.month == yesterday.month &&
    //       date.day == yesterday.day) {
    //     return "Yesterday";
    //   } else if (date.year == tomorrow.year &&
    //       date.month == tomorrow.month &&
    //       date.day == tomorrow.day) {
    //     return "Tomorrow";
    //   } else {
    //     return DateFormat('dd/MM/yyyy').format(date);
    //   }
  }

  String fromatDateLikeMonthDay(BuildContext context, String dateString) {
    DateTime date = DateTime.parse(dateString).toLocal();
    if (context.isArabic) {
      return DateFormat('MMMM d', 'ar').format(date);
    }
    return DateFormat('MMMM d', 'en').format(date);
  }

  // Function to format the timestamp to relative time (e.g., "4d ago")
  String getRelativeTime(BuildContext context, String createdDate) {
    final now = DateTime.now();
    final difference = now.difference(DateTime.parse(createdDate).toLocal());

    if (context.isArabic) {
      return timeago.format(now.subtract(difference), locale: 'ar_short');
    } else {
      return timeago.format(now.subtract(difference), locale: 'en_short');
    }
  }
}
