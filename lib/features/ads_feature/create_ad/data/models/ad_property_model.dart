import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';

import '../../../../../common/functions/helper/lang_helper.dart';

class AdPropertyModel extends AdPropertiesEntity {
  AdPropertyModel(
      {required super.label, required super.type, required super.values});
  factory AdPropertyModel.fromJson(Map<String, dynamic> json) {
    return AdPropertyModel(
      label: getLang() == 'ar' ? json['name_ar'] : json['name_en'],
      type: json['type'],
      values: json['selections'] == null
          ? []
          : (json['selections'] as List)
              .map((e) =>
                  getLang() == 'ar' ? e['ar'] as String : e['en'] as String)
              .toList(),
    );
  }
}
