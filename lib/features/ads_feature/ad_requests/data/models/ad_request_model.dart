import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';

class AdRequestModel extends AdRequestEntity {
  AdRequestModel(
      {required super.requestId,
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
      required super.updatedAt});

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
      );
}
