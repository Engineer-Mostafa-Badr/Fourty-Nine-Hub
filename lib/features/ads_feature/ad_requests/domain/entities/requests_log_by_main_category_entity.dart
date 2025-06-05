import 'package:fourtyninehub/core/utils/duration_helper.dart';

class RequestsLogByMainCategoryEntity {
  // final String requestId;
  final String userId;
  final String userName;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;
  final String gender;
  final String adId;
  final String adTitle;
  final String phone;
  final String adDesc;
  final bool isPremium;
  final num views;
  final String subCategoryId;
  final String subCategoryNameEn;
  final String subCategoryNameAr;
  // final num adPrice;
  // final String gender;
  // final String email;
  // final String requestUserId;
  // final String subCategoryId;
  // final String adUserId;
  // final bool enabled;
  final DateTime createdAt;
  // final DateTime updatedAt;

  Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime => DurationHelper().getTimeDifference(createdAt);

  RequestsLogByMainCategoryEntity({
    // required this.requestId,
    required this.userId,
    required this.adId,
    required this.subCategoryId,
    required this.userName,
    required this.adTitle,
    required this.phone,
    required this.adDesc,
    required this.gender,
    required this.createdAt,
    required this.isPremium,
    required this.views,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
    required this.subCategoryNameEn,
    required this.subCategoryNameAr,
    // required this.adPrice,
    // required this.gender,
    // required this.email,
    // required this.requestUserId,
    // required this.subCategoryId,
    // required this.adUserId,
    // required this.enabled,
    // required this.createdAt,
    // required this.updatedAt
  });
}
