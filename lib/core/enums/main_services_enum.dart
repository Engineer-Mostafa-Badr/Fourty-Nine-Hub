// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show describeEnum;

enum MainServicesEnum { ride, shipping, food, health }

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
    }
  }

  String get cover {
    switch (this) {
      case MainServicesEnum.ride:
        return '';
      case MainServicesEnum.shipping:
        return '';
      case MainServicesEnum.food:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/f501dacb-cc0f-4714-a1f0-52af60f9d999.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240720%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240720T110314Z&X-Amz-Expires=3600&X-Amz-Signature=50cb6ae0c34b0b65959c72b471c53914f4f9b9ead6f38d84bbb74bd3dfbaf541&X-Amz-SignedHeaders=host&x-id=GetObject';
      case MainServicesEnum.health:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/24def395-3161-445a-89bf-6238bd8bd380.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240720%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240720T110314Z&X-Amz-Expires=3600&X-Amz-Signature=198cb3d081c1882491df28b690bd0300f3ee5e9d9fde1a9302f0b4584b6f7435&X-Amz-SignedHeaders=host&x-id=GetObject';
    }
  }

  String get banner {
    switch (this) {
      case MainServicesEnum.ride:
        return '';
      case MainServicesEnum.shipping:
        return '';
      case MainServicesEnum.food:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/143555d5-d72d-47cd-a370-716866fa0f2e.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240720%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240720T110314Z&X-Amz-Expires=3600&X-Amz-Signature=4fa24a63b54a393da324459a775181ac4f5a2008da874df74245308a385c0f5c&X-Amz-SignedHeaders=host&x-id=GetObject';
      case MainServicesEnum.health:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/7143fb33-3a01-44b9-975a-71464a3cadde.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240720%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240720T110314Z&X-Amz-Expires=3600&X-Amz-Signature=76b55b2cb6086833d10643c5c2e6bd2d6c9078f3ab357993329291313586249a&X-Amz-SignedHeaders=host&x-id=GetObject';
    }
  }

  String value() {
    switch (this) {
      case MainServicesEnum.ride:
        return '62c8b5779332225799fe3304';
      case MainServicesEnum.shipping:
        return '62c8b5779332225799fe3302';
      case MainServicesEnum.food:
        return '62c8b57e9332225799fe3308';
      case MainServicesEnum.health:
        return '62c8b57f9332225799fe330a';
    }
  }
}
