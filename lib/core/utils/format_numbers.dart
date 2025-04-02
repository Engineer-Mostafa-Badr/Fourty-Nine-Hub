import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class FormatNumbers{
  String formatNumber(num number, {int decimals = 1}) {
    if (number >= 1000 && number < 1000000) {
      return '${(number / 1000).toStringAsFixed(decimals)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(decimals)}M';
    } else if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(decimals)}B';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  String formatNumberByComma(BuildContext context, String? balance) {
    if (balance == null || balance.isEmpty) {
      return "0"; // Fallback value if balance is null or empty
    }

    try {
      // return double.parse(balance).floor().toString();
      final NumberFormat formatter;
      if (context.isArabic) {
        formatter = NumberFormat('#,###');
      } else {
        formatter = NumberFormat('#,###', 'en');
      }

      return formatter.format(num.parse(balance));
    } catch (e) {
      // If parsing fails, return a fallback value or handle the error as needed
      return "0";
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