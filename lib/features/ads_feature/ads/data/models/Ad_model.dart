import 'package:fourtyninehub/features/ads_feature/ads/data/models/ad_statistics_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/create_ad_model.dart';

import '../../../../authentication/data/models/user_model.dart';
import '../../../../requests_history/data/models/address_model.dart';
import '../../domain/entities/ad_entity.dart';

class AdModel extends AdEntity {
  AdModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.images,
      super.price,
      super.type,
      super.city,
      super.governorate,
      super.isFavourite,
      super.hasAuction,
      super.address,
      super.user,
      super.mainCategoryId,
      super.userId,
      super.statistics,
      required super.active,
      required super.approved,
      required super.createdAt,
      required super.details,
      super.subCategoryId,
      super.phone});
  factory AdModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    try {
      images =
          (json['images'] as List).map((e) => e['photo'] as String).toList();
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
        active: json['isActive'] ?? true,
        approved: json['isApproved'] ?? true,
        isFavourite: json['isFavorite'] ?? false,
        // phone: json['phone'] ?? '',
        statistics: json['statistics'] == null
            ? null
            : AdStatisticsModel.fromJson(json['statistics']),
        address: AddressModel.fromJson(json['address']),
        user: user,
        details: json['props'] == null
            ? []
            : (json['props'] as List)
                .map((e) => CreateAdModel.fromJson(e))
                .toList(),
        createdAt: DateTime.parse(json['createdAt']));
  }
  Map<String, dynamic> toJson() => {
        "desc": description,
        "phone": phone,
        "title": title,
        "type": type,

        // "type": (hasAuction==false&&isUser==false)?"provider":(hasAuction==false&&isUser==true)?"user":(hasAuction==true&&isUser==false)?'rent':'sale',
        "subCategoryId": subCategoryId,
        "mainCategoryId": mainCategoryId,
        if (price != null) "price": price,
        // "userId": userId,
        "searchText": "testPropsAndAds",
        "images": images,
        "props": details.map((e) {
          if (e.value.nameEn.isNotEmpty) {
            return {
              "value": {"ar": e.value.nameAr, "en": e.value.nameEn},
              "propertyId": e.propId
            };
          }
        }).toList(),
    "address": {
      "government": governorate,
      "city": city
      }
      };
}
