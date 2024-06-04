// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show describeEnum;

enum MainServicesEnum {
  ride,
  shipping,
}

extension MainServicesEnumExtention on MainServicesEnum {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case MainServicesEnum.ride:
        return 'Ride';
      case MainServicesEnum.shipping:
        return 'Shipping';
    }
  }

  String value() {
    switch (this) {
      case MainServicesEnum.ride:
        return '62c8b5779332225799fe3304';
      case MainServicesEnum.shipping:
        return '62c8b5779332225799fe3302';
    }
  }
}

MainServicesEnum getRideServiceEnum({
  required String value,
}) {
  switch (value) {
    case '62c8b5779332225799fe3302':
      return MainServicesEnum.shipping;
    case '62c8b5779332225799fe3304':
      return MainServicesEnum.ride;
    
  }
  return MainServicesEnum.ride;
}
