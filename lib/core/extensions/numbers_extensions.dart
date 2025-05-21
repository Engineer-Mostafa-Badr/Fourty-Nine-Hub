import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String numAr(num number) {
  final formatter = NumberFormat('#,##0.###', 'ar_EG');
  return formatter.format(number);
}
String convertToArabicNumbers(String input) {
  const englishToArabic = {
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
  };

  return input.split('').map((char) {
    return englishToArabic[char] ?? char;
  }).join();
}
extension NumberExtensions on num {
  String toLocalizedArabic(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ar') {
      final formatter = NumberFormat('#,##0.###', 'ar_EG');
      return formatter.format(this);
    } else {
      return toString();
    }
  }
}

extension StringExtensions on String {
  String toArabicNumbers(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale != 'ar') return this;

    const englishToArabic = {
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
    };

    return split('').map((char) => englishToArabic[char] ?? char).join();
  }
}
