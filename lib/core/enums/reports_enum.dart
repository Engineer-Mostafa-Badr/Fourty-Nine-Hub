// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show describeEnum;

enum ReportsEnum { nudity, frequent, fake, abuse,hated,illegal,politics }

extension ReportsEnumExtention on ReportsEnum {
  String get name => describeEnum(this);
  String get category {
    switch (this) {
      case ReportsEnum.nudity:
        return 'nudity';
      case ReportsEnum.frequent:
        return 'frequent';
      case ReportsEnum.fake:
        return 'fake';
      case ReportsEnum.abuse:
        return 'abuse';
      case ReportsEnum.hated:
        return 'hated';
      case ReportsEnum.illegal:
        return 'illegal';
      case ReportsEnum.politics:
        return 'politics';
    }
  }

  String get displayTitleEn {
    switch (this) {
      case ReportsEnum.nudity:
        return 'This content contains explicit nudity and is inappropriate for general audiences.';
      case ReportsEnum.frequent:
        return 'Please investigate the frequency of this user\'s posts.';
      case ReportsEnum.fake:
        return 'The content in question is deceptive and should be verified for authenticity.';
      case ReportsEnum.abuse:
        return 'The content reported involves abusive language or behavior.';
      case ReportsEnum.hated:
        return 'This report concerns content that promotes hate speech or discrimination.';
      case ReportsEnum.illegal:
        return 'The content reported is suspected of promoting illegal activities.';
      case ReportsEnum.politics:
        return 'Illegal activities are strictly prohibited on our platform.';
    }
  }


  String get displayTitleAr {
    switch (this) {
      case ReportsEnum.nudity:
        return 'يحتوي هذا المحتوى على عري صريح وهو غير مناسب للجماهير العامة.';
      case ReportsEnum.frequent:
        return 'النشر المفرط لنفس الرسالة يعطل تجربة المستخدم.';
      case ReportsEnum.fake:
        return 'يبرز هذا التقرير انتشار الأخبار الزائفة أو المعلومات المضللة.';
      case ReportsEnum.abuse:
        return 'المحتوى المبلغ عنه يتضمن لغة أو سلوكاً مسيئاً.';
      case ReportsEnum.hated:
        return 'يتعلق هذا التقرير بمحتوى يروج لخطاب الكراهية أو التمييز.';
      case ReportsEnum.illegal:
        return 'المحتوى المبلغ عنه مشتبه في ترويجه لأنشطة غير قانونية.';
      case ReportsEnum.politics:
        return 'يتضمن المحتوى المعني دعاية سياسية أو معلومات متحيزة.';
    }
  }

}
