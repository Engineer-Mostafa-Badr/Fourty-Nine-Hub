import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';

class RequestsLogByMainCategoryModel extends RequestsLogByMainCategoryEntity {
  RequestsLogByMainCategoryModel({
    // required super.requestId,
    required super.userId,
    required super.adId,
    required super.userName,
    required super.adTitle,
    required super.phone,
    required super.subCategoryId,
    required super.adDesc,
    required super.gender,
    required super.createdAt,
    required super.isPremium,
    required super.views,
    required super.firstName,
    required super.lastName,
    required super.profilePictureUrl,
    required super.subCategoryNameEn,
    required super.subCategoryNameAr,
  });

  factory RequestsLogByMainCategoryModel.fromJson(Map<String, dynamic> json) =>
      RequestsLogByMainCategoryModel(
        // requestId: json['_id'] ?? '',
        userId: json['user']?['id'] ?? '',
        firstName: json['user']?['firstName'] ?? '',
        lastName: json['user']?['lastName'] ?? '',
        profilePictureUrl: json['user']?['profilePictureUrl'] ?? '',
        gender: json['user']?['gender'] ?? '',
        userName: json['user']?['username'] ?? '',
        adId: json['ad']?['id'] ?? '',
        subCategoryId: json['ad']?['subCategory']?['_id'] ?? '',
        subCategoryNameAr: json['ad']?['subCategory']?['nameAr'] ?? '',
        subCategoryNameEn: json['ad']?['subCategory']?['nameEn'] ?? '',
        adTitle: json['ad']?['title'] ?? '',
        phone: json['ad']?['phone'] ?? '',
        adDesc: json['ad']?['desc'] ?? '',
        isPremium: json['ad']?['isPremium'] ?? false,
        views: json['ad']?['views'] ?? 0,
        createdAt: json['ad']?['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );
}
