import 'package:fourtyninehub/features/ads_feature/ads/data/models/ad_details_prop_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/ad_statistics_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_entity.dart';

import '../../../../authentication/data/models/user_model.dart';
import '../../../../requests_history/data/models/address_model.dart';

class AddDetailsModel extends AdDetailsEntity {
  AddDetailsModel({
    required super.id,
    super.userId,
    super.mainCategoryId,
    super.subCategoryId,
    required super.title,
    required super.description,
    required super.images,
    super.isPrimary,
    super.isDeleted,
    super.price,
    super.type,
    super.cityAr,
    super.cityEn,
    super.governorateAr,
    super.governorateEn,
    super.status,
    super.phone,
    super.views,
    super.requestsCount,
    super.subscriptionStatus,
    super.isFavourite,
    super.address,
    super.user,
    super.statistics,
    required super.active,
    required super.createdAt,
    required super.details,
  });
  factory AddDetailsModel.fromJson(Map<String, dynamic> json) {
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
    return AddDetailsModel(
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        cityAr: json['cityData'] != null
            ? (json['cityData']['city_name_ar'] ?? '')
            : '',
        cityEn: json['cityData'] != null
            ? (json['cityData']['city_name_en'] ?? '')
            : '',
        governorateAr: json['governmentData'] != null
            ? (json['governmentData']['governorate_name_ar'] ?? '')
            : '',
        governorateEn: json['governmentData'] != null
            ? (json['governmentData']['governorate_name_en'] ?? '')
            : '',
        subCategoryId: json['subCategoryId'] ?? '',
        mainCategoryId: json['mainCategoryId'] ?? '',
        title: json['title'] ?? '',
        description: json['desc'] ?? '' ?? json['description'] ?? '',
        images: images,
        isPrimary: json['isPremium'] ?? false,
        isDeleted: json['isDeleted'] ?? false,
        status: json['status'] ?? '',
        phone: json['phone'] ?? '',
        requestsCount: json['requestsCount'] ?? 0,
        type: json['type'] ?? '',
        views: json['views'] ?? 0,
        price: json['price'] ?? 0,
        active: json['active'] ?? true,
        isFavourite: json['isFavorite'] ?? false,
        // phone: json['phone'] ?? '',
        subscriptionStatus: json['subscriptionStatus'] ?? '',
        statistics: json['statistics'] == null
            ? null
            : AdStatisticsModel.fromJson(json['statistics']),
        address: AddressModel.fromJson(json['address']),
        user: user,
        details: json['props'] == null
            ? []
            : (json['props'] as List)
                .map((e) => AdDetailsPropModel.fromJson(e))
                .toList(),
        createdAt: DateTime.parse(json['createdAt']));
  }
}
