import 'package:fourtyninehub/features/ads_feature/ads/data/models/ad_statistics_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/create_ad_model.dart';

import '../../../../authentication/data/models/user_model.dart';
import '../../domain/entities/ad_entity.dart';
import 'ads_address_model.dart';

class AdModel extends AdEntity {
  AdModel({
    required super.id,
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
    super.subscriptionStatus,
    super.userSubscriptionStatus,
    super.views,
    super.statistics,
    required super.active,
    required super.approved,
    required super.createdAt,
    required super.details,
    super.subCategoryId,
    super.subCategoryNameEn,
    super.subCategoryNameAr,
    super.phone,
    super.currencyEn,
    super.currencyAr,
  });
  factory AdModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    // try {
    images = (json['images'] as List).map((e) => e['photo'] as String).toList();
    // } catch (e) {}
    UserModel? user;
    // try {
    // if (json['userId'] != null) {
    //   user = UserModel.fromJson(json['userId']);
    // }
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
    // } catch (e) {}
    return AdModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['desc'] ?? json['description'],
      images: images,
      price: json['price'] ?? 0,
      subCategoryId: json['subCategoryId'],
      subCategoryNameEn: json['subCategory']?['nameEn'] ?? '',
      subCategoryNameAr: json['subCategory']?['nameAr'] ?? '',
      active: json['isActive'] ?? true,
      approved: json['isApproved'] ?? true,
      isFavourite: json['isFavorite'] ?? false,
      subscriptionStatus: json['ownerSubscriptionStatus'] ?? '',
      views: json['views'] ?? 0,
      userSubscriptionStatus: json['userLoginSubscriptionStatus'] ?? '',
      phone: json['phone'] ?? '',
      userId: json['userId'],
      statistics: json['statistics'] == null
          ? null
          : AdStatisticsModel.fromJson(json['statistics']),
      address: AdsAddressModel.fromJson(json['address']),
      user: user,
      details: json['props'] == null
          ? []
          : (json['props'] as List)
              .map((e) => CreateAdModel.fromJson(e))
              .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      currencyEn: json['currencyEn'] ?? '',
      currencyAr: json['currencyAr'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        "desc": description,
        "phone": phone,
        "title": title,
        "type": type,

        // "type": (hasAuction==false&&isUser==false)?"provider":(hasAuction==false&&isUser==true)?"user":(hasAuction==true&&isUser==false)?'rent':'sale',
        "subCategoryId": subCategoryId,
        "mainCategoryId": mainCategoryId,
        // TODO: add the user model
        // if (price != null) "price": price,
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
        // TODO: add the address model
        // "address": {"government": governorate, "city": city}
        "address": {
          "type": "Point",
          "coordinates": [30.030030, 30.5262]
        }
      };
}
