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
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/f501dacb-cc0f-4714-a1f0-52af60f9d999.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240721%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240721T173840Z&X-Amz-Expires=3600&X-Amz-Signature=9db2ddab5e1c5049c62d70600bd6aa3193de2e81c850f0199b9fe61df51c84ce&X-Amz-SignedHeaders=host&x-id=GetObject';
      case MainServicesEnum.health:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/24def395-3161-445a-89bf-6238bd8bd380.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240721%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240721T173840Z&X-Amz-Expires=3600&X-Amz-Signature=8d627e0a8bc742519870a470542048ef152c1f5d4f19010b2a1612537ab28983&X-Amz-SignedHeaders=host&x-id=GetObject';
    }
  }

  String get banner {
    switch (this) {
      case MainServicesEnum.ride:
        return '';
      case MainServicesEnum.shipping:
        return '';
      case MainServicesEnum.food:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/143555d5-d72d-47cd-a370-716866fa0f2e.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240721%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240721T173840Z&X-Amz-Expires=3600&X-Amz-Signature=39379c2bb2b4aacc33413abec8cee769171dd98d1418fa4cd489589297a74bd6&X-Amz-SignedHeaders=host&x-id=GetObject';
      case MainServicesEnum.health:
        return 'https://49hub.s3.eu-central-1.amazonaws.com/DO/7143fb33-3a01-44b9-975a-71464a3cadde.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240721%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240721T173840Z&X-Amz-Expires=3600&X-Amz-Signature=0194ec8c70d7b4e7ab904f3e903c09aa039881ae1186294671ace16050c1dda4&X-Amz-SignedHeaders=host&x-id=GetObject';
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
