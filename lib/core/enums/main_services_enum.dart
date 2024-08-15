// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show describeEnum;

enum MainServicesEnum { ride, shipping, food, health, medicalServices }

extension MainServicesEnumExtention on MainServicesEnum {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case MainServicesEnum.ride:
        return 'Ride';
      case MainServicesEnum.shipping:
        return 'Shipping';
      case MainServicesEnum.food:
        return 'Food';
      case MainServicesEnum.health:
        return 'Health';
      case MainServicesEnum.medicalServices:
        return 'Medical Services';
    }
  }

  String get id {
    switch (this) {
      case MainServicesEnum.ride:
        return '62c8b5779332225799fe3304';
      case MainServicesEnum.shipping:
        return '62c8b5779332225799fe3302';
      case MainServicesEnum.food:
        return '62c8b57e9332225799fe3308';
      case MainServicesEnum.health:
        return '62c8b57c9332225799fe3306';
      case MainServicesEnum.medicalServices:
        return '62c8b57f9332225799fe330a';
    }
  }
}
