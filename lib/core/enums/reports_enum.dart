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

  String get displayTitle {
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
        return 'politics';    }
  }

}
