import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_prop_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_statistics_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/duration_helper.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../requests_history/domain/entities/address_entity.dart';

class AdDetailsEntity {
  final String id;
  final String? userId;
  final String? subCategoryId;
  final String? mainCategoryId;
  final String? cityAr;
  final String? cityEn;
  final String? governorateAr;
  final String? governorateEn;
  final String? subscriptionStatus;
  final String title;
  final String description;
  final List<String> images;
  bool? isPrimary;
  final num? price;
  final String? status;
  final String? phone;
  final num? views;
  final num? requestsCount;
  final String? type;
  bool? isFavourite;
  bool? isDeleted;
  final bool active;
  final AdStatisticsEntity? statistics;
  final AddressEntity? address;
  final UserEntity? user;
  List<AdDetailsPropEntity> details;
  DateTime createdAt;
  String get formatedDate => DateFormat('yyyy-MM-dd').format(createdAt);
  Duration get restTimeDuration => DateTime.now().difference(createdAt);

  String get formattedRestTime =>
      DurationHelper().sinceTime(duration: restTimeDuration);

  AdDetailsEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      this.price,
      this.type,
      this.cityAr,
      this.cityEn,
      this.governorateAr,
      this.governorateEn,
      this.status,
      this.views,
      this.requestsCount,
      this.subscriptionStatus,
      this.isFavourite = false,
      this.isDeleted = false,
      this.isPrimary = false,
      required this.address,
      this.phone,
      this.statistics,
      required this.user,
      this.subCategoryId,
      this.mainCategoryId,
      this.userId,
      required this.active,
      required this.details,
      required this.createdAt});
}
