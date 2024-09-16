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
       super.price,
        super.isUser,
      super.address,
      super.user,
        super.mainCategoryId,
        super.userId,
      super.statistics,
      required super.active,
      required super.createdAt,
      required super.details,
      super.subCategoryId, super.phone});
  factory AdModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    try {
      images =
          (json['images'] as List).map((e) => e['mediaKey'] as String).toList();
    } catch (e) {}
    UserModel? user;
    try {
      if (json['userId'] != null) {
        user = UserModel.fromJson(json['userId']);
      }
      if (json['user'] != null) {
        user = UserModel.fromJson(json['user']);
      }
    } catch (e) {}
    return AdModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        description: json['desc'] ?? json['description'],
        images: images,
        price: json['price'] ?? 0,
        subCategoryId: json['subCategoryId'],
        active: json['active'] ?? true,
        // phone: json['phone'] ?? '',
        statistics: json['statistics'] == null
            ? null
            : AdStatisticsModel.fromJson(json['statistics']),
        address: AddressModel.fromJson(json['address']),
        user: user,
        details: json['props'] == null
            ? []
            : (json['props'] as List)
                .map((e) => DetailModel.fromJson(e))
                .toList(),
        createdAt: DateTime.parse(json['createdAt']));
  }
  Map<String, dynamic> toJson() => {
        "desc": description,
        // "phone": phone,
        "title": title,
        "type": isUser==false?"provider":"user",
        "subCategoryId": subCategoryId,
        "mainCategoryId": mainCategoryId,
        // "userId": userId,
        "searchText": "testPropsAndAds",
        "images": images,
        "props": details.map((e) {
          return {"label": e.label, "value": e.value, "type": e.type};
        }).toList()
      };
}
