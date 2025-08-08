import '../../../../core/utils/duration_helper.dart';

class AdRequestEntity {
  final String requestId;
  final String adId;
  final String userName;
  final String adTitle;
  final String phone;
  final String adDesc;
  final num adPrice;
  final String gender;
  final String email;
  final String requestUserId;
  final String subCategoryId;
  final String adUserId;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime => DurationHelper().getTimeDifference(createdAt);

  AdRequestEntity(
      {required this.requestId,
      required this.adId,
      required this.subCategoryId,
      required this.userName,
      required this.adTitle,
      required this.phone,
      required this.adDesc,
      required this.adPrice,
      required this.gender,
      required this.email,
      required this.requestUserId,
      required this.adUserId,
      required this.enabled,
      required this.createdAt,
      required this.updatedAt});
}
