import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_statistics_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/duration_helper.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import 'ads_address_entity.dart';

class DataAdEntity {
  final List<AdModel> ads;
  final String currencyEn;
  final String currencyAr;
  final PaginationDetailsEntity paginationDetails;

  DataAdEntity({
    required this.ads,
    required this.paginationDetails,
    required this.currencyEn,
    required this.currencyAr,
  });
}

class PaginationDetailsEntity {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationDetailsEntity({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });
}

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
  final AdsAddressEntity? address;
  final UserEntity? user;
  List<CreateAdEntity> details;
  DateTime createdAt;
  final String? phone;
  final String? subCategoryId;
  final String? mainCategoryId;
  final String? userId;
  final String? subscriptionStatus;
  final num? views;
  final String? userSubscriptionStatus;
  final String? currencyEn;
  final String? currencyAr;
  String get formatedDate => DateFormat('yyyy-MM-dd').format(createdAt);
  Duration get restTimeDuration => DateTime.now().difference(createdAt);

  String get formattedRestTime =>
      DurationHelper().sinceTime(duration: restTimeDuration);

  AdEntity({
    required this.id,
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
    this.subscriptionStatus,
    this.userSubscriptionStatus,
    this.views,
    required this.active,
    required this.approved,
    required this.details,
    required this.createdAt,
    this.currencyEn,
    this.currencyAr,
  });
}
