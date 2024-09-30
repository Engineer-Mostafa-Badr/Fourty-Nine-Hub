// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show describeEnum;

import '../localization/locale_keys.g.dart';

enum ReportsEnum { nudity, frequent, fake, abuse, hated, illegal, politics }

extension ReportsEnumExtention on ReportsEnum {
  String get name => describeEnum(this);

  String get category {
    switch (this) {
      case ReportsEnum.nudity:
        return LocaleKeys.report_category_nudity.tr();
      case ReportsEnum.frequent:
        return LocaleKeys.report_category_frequent.tr();
      case ReportsEnum.fake:
        return LocaleKeys.report_category_fake.tr();
      case ReportsEnum.abuse:
        return LocaleKeys.report_category_abuse.tr();
      case ReportsEnum.hated:
        return LocaleKeys.report_category_hated.tr();
      case ReportsEnum.illegal:
        return LocaleKeys.report_category_illegal.tr();
      case ReportsEnum.politics:
        return LocaleKeys.report_category_politics.tr();
    }
  }

  String get displayTitleEn {
    switch (this) {
      case ReportsEnum.nudity:
        return LocaleKeys.report_nudity.tr();
      case ReportsEnum.frequent:
        return LocaleKeys.report_frequent.tr();
      case ReportsEnum.fake:
        return LocaleKeys.report_fake.tr();
      case ReportsEnum.abuse:
        return LocaleKeys.report_abuse.tr();
      case ReportsEnum.hated:
        return LocaleKeys.report_hated.tr();
      case ReportsEnum.illegal:
        return LocaleKeys.report_illegal.tr();
      case ReportsEnum.politics:
        return LocaleKeys.report_politics.tr();
    }
  }

  String get displayTitleAr {
    switch (this) {
      case ReportsEnum.nudity:
        return LocaleKeys.report_nudity.tr();
      case ReportsEnum.frequent:
        return LocaleKeys.report_frequent.tr();
      case ReportsEnum.fake:
        return LocaleKeys.report_fake.tr();
      case ReportsEnum.abuse:
        return LocaleKeys.report_abuse.tr();
      case ReportsEnum.hated:
        return LocaleKeys.report_hated.tr();
      case ReportsEnum.illegal:
        return LocaleKeys.report_illegal.tr();
      case ReportsEnum.politics:
        return LocaleKeys.report_politics.tr();
    }
  }
}
