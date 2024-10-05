import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_statistics_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/duration_helper.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../requests_history/domain/entities/address_entity.dart';

class AdEntity {
  final String id;
  final String title;
  String? type;
  String? city;
  String? governorate;
  bool? hasAuction;
  bool? isFavourite;
  final String description;
  final List<String> images;
  final num? price;
  final bool active;
  final bool approved;
  final AdStatisticsEntity? statistics;
  final AddressEntity? address;
  final UserEntity? user;
  List<CreateAdEntity> details;
  DateTime createdAt;
  final String? phone;
  final String? subCategoryId;
  final String? mainCategoryId;
  final String? userId;
  String get formatedDate => DateFormat('yyyy-MM-dd').format(createdAt);
  Duration get restTimeDuration => DateTime.now().difference(createdAt);

  String get formattedRestTime => DurationHelper().sinceTime(duration: restTimeDuration);

  AdEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      this.price,
      this.city,
      this.governorate,
      this.type,
      this.isFavourite = false,
      this.hasAuction = false,
      required this.address,
      this.phone,
      this.statistics,
      required this.user,
      this.subCategoryId,
      this.mainCategoryId,
      this.userId,
      required this.active,
      required this.approved,
      required this.details,
      required this.createdAt});
}
