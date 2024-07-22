import 'package:fourtyninehub/features/ads_feature/ads/data/models/ad_statistics_model.dart';

import '../../../../authentication/data/models/user_model.dart';
import '../../../../requests_history/data/models/address_model.dart';
import '../../domain/entities/ad_entity.dart';
import 'detail_model.dart';


class AdModel extends AdEntity {
  AdModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.images,
      required super.price,
       super.address,
       super.user,
      super.statistics,
      required super.active,
      required super.createdAt,
      required super.details,
       super.subCategoryId, required super.phone});
  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
        id: json['_id'],
        title: json['title'],
        description: json['desc'],
        images: (json['images'] as List).map((e)=> e['mediaKey'] as String).toList(),
        price: json['price'],
        subCategoryId: json['subCategoryId'],
        active: json['active'] ?? true,
        phone: json['phone'],
        statistics: json['statistics'] == null
            ? null
            : AdStatisticsModel.fromJson(json['statistics']),
        address: AddressModel.fromJson(json['address']),
        user: UserModel.fromJson(json['userId']),
        details: json['props'] == null
            ? []
            : (json['props'] as List)
                .map((e) => DetailModel.fromJson(e))
                .toList(),
        createdAt: DateTime.parse(json['createdAt']));
  }
  Map<String, dynamic> toJson() => {
        "desc": description,
        "phone": phone,
        "title": title,
        "subCategoryId": subCategoryId,
        "searchText": "testPropsAndAds",
        "images": images,
        "props": details.map((e) {
          return {"label": e.label, "value": e.value, "type": e.type};
        }).toList()
      };
}
