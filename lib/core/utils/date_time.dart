import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locales.dart';

String formatDateTime(String createdAt, BuildContext context) {
  final DateTime parsedDate = DateTime.parse(createdAt);
  final DateTime egyptTime = parsedDate.toUtc().add(const Duration(hours: 3));

  return context.locale == Locales.english
      ? DateFormat('dd/MM/yyyy, h:mm a', 'en').format(egyptTime)
      : DateFormat('yyyy/MM/dd, h:mm a', 'ar').format(egyptTime);
}
