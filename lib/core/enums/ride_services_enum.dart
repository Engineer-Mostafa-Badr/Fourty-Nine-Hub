// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show describeEnum;

enum RideServicesEnum {

  pickMe,
  comeWithYou,
  womenOnly,
  captain,
  taxi,
  scooter,
  intercity,
  premium
}

extension RideServicesEnumExtension on RideServicesEnum {
  String get name => describeEnum(this);

  String value() {
    switch (this) {
     
     
      case RideServicesEnum.pickMe:
        return '62ea008d69ea29c91dfc3908';
      case RideServicesEnum.womenOnly:
        return 'Women Only';
      case RideServicesEnum.captain:
        return '62c8ba9f8e28a58a3edf57eb';
      case RideServicesEnum.taxi:
        return 'Taxi';
      case RideServicesEnum.scooter:
        return 'Scooter';
      case RideServicesEnum.intercity:
        return 'Intercity';
      case RideServicesEnum.premium:
        return 'Premium';
      case RideServicesEnum.comeWithYou:
        return '62c8b5779332225799fe3304';
    }
  }
}

RideServicesEnum getRideServiceEnum({
  required String value,
}) {
  switch (value) {
   
    case '62ea008d69ea29c91dfc3908':
      return RideServicesEnum.pickMe;
    case 'Trip Join':
      return RideServicesEnum.womenOnly;
    case '62c8ba9f8e28a58a3edf57eb':
      return RideServicesEnum.captain;
    case 'Trip Join':
      return RideServicesEnum.taxi;
    case 'Trip Join':
      return RideServicesEnum.scooter;
    case 'Trip Join':
      return RideServicesEnum.intercity;
    case 'Trip Join':
      return RideServicesEnum.premium;
    case '62ea00e269ea29c91dfc390c':
      return RideServicesEnum.comeWithYou;
  }
  return RideServicesEnum.premium;
}
