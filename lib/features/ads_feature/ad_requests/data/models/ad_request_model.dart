import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';

class AdRequestModel extends AdRequestEntity {
  AdRequestModel({
    required super.requestId,
    required super.adId,
    required super.userName,
    required super.adTitle,
    required super.phone,
    required super.adDesc,
    required super.adPrice,
    required super.gender,
    required super.email,
    required super.requestUserId,
    required super.subCategoryId,
    required super.adUserId,
    required super.enabled,
    required super.createdAt,
    required super.updatedAt,
    required super.firstName,
    required super.lastName,
    required super.profilePictureUrl,
    required super.userId,
    required super.isPremium,
    required super.subCategoryNameAr,
    required super.subCategoryNameEn,
    required super.views,
  });

  factory AdRequestModel.fromJson(Map<String, dynamic> json) => AdRequestModel(
        requestId: json['_id'] ?? '',
        adId: json['adId']['_id'] ?? '',
        subCategoryId: json['adId']['subcategoryId'] ?? '',
        userName: json['username'],
        adTitle: json['adId']['title'] ?? '',
        phone: json['userMakeRequestPhone'] ?? '',
        adDesc: json['adId']['desc'] ?? '',
        adPrice: json['adId']['price'] ?? '',
        gender: json['userIdMakeRequest']['gender'] ?? '',
        email: json['userIdMakeRequest']['email'] ?? '',
        requestUserId: json['userIdMakeRequest']['_id'] ?? '',
        adUserId: json['adId']['userId'] ?? '',
        enabled: json['enable'] ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
        firstName: json['userIdMakeRequest']?['firstName'] ?? '',
        lastName: json['userIdMakeRequest']?['lastName'] ?? '',
        profilePictureUrl:
            json['userIdMakeRequest']?['profilePictureUrl'] ?? '',
        userId: json['userIdMakeRequest']?['_id'] ?? '',
        isPremium: json['isPremium'] ?? false,
        subCategoryNameAr: json['adId']?['subCategoryNameAr'] ?? '',
        subCategoryNameEn: json['adId']?['subCategoryNameEn'] ?? '',
        views: json['views'] ?? 0,
      );
}
