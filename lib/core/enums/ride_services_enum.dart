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
  pickup,
  suv,
  premium
}

extension RideServicesEnumExtension on RideServicesEnum {
  String get name => describeEnum(this);
  bool get isCaptain => this == RideServicesEnum.captain;
  bool get isWomenOnly => this == RideServicesEnum.womenOnly;
  bool get isTaxi => this == RideServicesEnum.taxi;
  bool get isScooter => this == RideServicesEnum.scooter;
  String value() {
    switch (this) {
      case RideServicesEnum.pickMe:
        return '62ea008d69ea29c91dfc3908';
      case RideServicesEnum.womenOnly:
        return '62ea012a69ea29c91dfc3917';
      case RideServicesEnum.captain:
        return '62c8ba9f8e28a58a3edf57eb';
      case RideServicesEnum.taxi:
        return 'Taxi';
      case RideServicesEnum.scooter:
        return '62c8baac8e28a58a3edf5803';
      case RideServicesEnum.intercity:
        return '62c8baa08e28a58a3edf57ed';
      case RideServicesEnum.premium:
        return '62c8baa38e28a58a3edf57f3';
      case RideServicesEnum.comeWithYou:
        return '62ea00e269ea29c91dfc390c';
      case RideServicesEnum.pickup:
        return '62c8baa18e28a58a3edf57ef';
      case RideServicesEnum.suv:
        return "62c8baa28e28a58a3edf57f1";
    }
  }

  String title() {
    switch (this) {
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
      case RideServicesEnum.comeWithYou:
        return 'Trip Join';
      case RideServicesEnum.pickup:
        return 'Pick up';
      case RideServicesEnum.suv:
        return 'SUV';
    }
  }

  String image() {
    switch (this) {
      case RideServicesEnum.pickMe:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/main/1/22.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=f741903f4adf72ebebfa9737865a4d78a1f2dae258ca27e09e21b95201f87586&X-Amz-SignedHeaders=host&x-id=GetObject';
      case RideServicesEnum.womenOnly:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/main/d2db7963-556f-4074-af74-313b5d0dbc3d.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=1a3e79906dc130a5cc799beac7beb9cbbdf9edfd0475677f7eb6701006227db1&X-Amz-SignedHeaders=host&x-id=GetObject';
      case RideServicesEnum.captain:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/main/1/2.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=868074a464be188d3215a42f7c98d3f2c4550c953f0bbf9eb9e89e6c80292a22&X-Amz-SignedHeaders=host&x-id=GetObject';
      case RideServicesEnum.taxi:
        return 'Taxi';
      case RideServicesEnum.scooter:
        return "https://49hub.s3.eu-central-1.amazonaws.com/DO/main/1/14.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=871248c6c2545d249c2a0246cbd8890635a50c40992a22235955eb44c9e63fdc&X-Amz-SignedHeaders=host&x-id=GetObject";
      case RideServicesEnum.intercity:
        return "https://49hub.s3.eu-central-1.amazonaws.com/DO/main/1/3.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=96c59b940bd915eedce586805e104f994c0584a4667fc264188b1051cdef4b82&X-Amz-SignedHeaders=host&x-id=GetObject";
      case RideServicesEnum.premium:
        return "https://49hub.s3.eu-central-1.amazonaws.com/DO/main/1/6.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=679fbf76f93caf78066cadd64c5d6fc6ecb71f57dc59a4d9ab2733c449666d32&X-Amz-SignedHeaders=host&x-id=GetObject";
      case RideServicesEnum.comeWithYou:
        return "https://49hub.s3.eu-central-1.amazonaws.com/DO/https%3A//49-space.fra1.digitaloceanspaces.com/main/1/21.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=bc3a62a17d5c677029881e3124f997e8021374b609998fdad12a0f1f44513d7f&X-Amz-SignedHeaders=host&x-id=GetObject";

      case RideServicesEnum.pickup:
        return "https://49hub.s3.eu-central-1.amazonaws.com/DO/main/1/4.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=ecc193ee3dd5d2a4115607b8c74e00fc83a88dd2cdde7b14260221ad99300dea&X-Amz-SignedHeaders=host&x-id=GetObject";
      case RideServicesEnum.suv:
        return "https://49hub.s3.eu-central-1.amazonaws.com/DO/main/1/5.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240717%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240717T180920Z&X-Amz-Expires=3600&X-Amz-Signature=843616d8b4844226ad4a49e6efbf3cb06484394654bb96a01400814e13d75d78&X-Amz-SignedHeaders=host&x-id=GetObject";
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
