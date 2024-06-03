// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show describeEnum;

enum RideServicesEnum {
  tripJoin,
  pickMe,
  womenOnly,
  captain,
  taxi,
  scooter,
  intercity,
  premium
}

extension RideServicesEnumExtension on RideServicesEnum {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case RideServicesEnum.tripJoin:
        return 'Trip Join';
      case RideServicesEnum.pickMe:
        return 'Pick Me';
      case RideServicesEnum.womenOnly:
        return 'Women Only';
      case RideServicesEnum.captain:
        return 'Captain';
      case RideServicesEnum.taxi:
        return 'Taxi';
      case RideServicesEnum.scooter:
        return 'Scooter';
      case RideServicesEnum.intercity:
        return 'Intercity';
      case RideServicesEnum.premium:
        return 'Premium';
    }
  }

  String value() {
    switch (this) {
      case RideServicesEnum.tripJoin:
        return 'Trip Join';
      case RideServicesEnum.pickMe:
        return 'Pick Me';
      case RideServicesEnum.womenOnly:
        return 'Women Only';
      case RideServicesEnum.captain:
        return 'Captain';
      case RideServicesEnum.taxi:
        return 'Taxi';
      case RideServicesEnum.scooter:
        return 'Scooter';
      case RideServicesEnum.intercity:
        return 'Intercity';
      case RideServicesEnum.premium:
        return 'Premium';
    }
  }
}

RideServicesEnum getRideServiceEnum({
  required String value,
}) {
  switch (value) {
    case 'Trip Join':
      return RideServicesEnum.tripJoin;
    case 'Trip Join':
      return RideServicesEnum.pickMe;
    case 'Trip Join':
      return RideServicesEnum.womenOnly;
    case 'Trip Join':
      return RideServicesEnum.captain;
    case 'Trip Join':
      return RideServicesEnum.taxi;
    case 'Trip Join':
      return RideServicesEnum.scooter;
    case 'Trip Join':
      return RideServicesEnum.intercity;
    case 'Trip Join':
      return RideServicesEnum.premium;
  }
  return RideServicesEnum.premium;
}
