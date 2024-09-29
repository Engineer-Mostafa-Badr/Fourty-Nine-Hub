import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/subscription_ad_auction_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/user_auction_entity.dart';
import 'ads_entity.dart';

class MyAuctionAdsEntity {
  final String id;
  final String name;
  final bool adminIgnore;
  final String userId;
  final double startPrice;
  final bool isFinished;
  final String startDate;
  final bool isApproved;
  final String supCategory;
  final String mainCategory;
  final double smallPrice;
  final double needPrice;
  final String adId;
  final bool isPremium;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final AdDataAuctionEntity ad;
  final UserAuctionEntity user;
  final List<SubscriptionAdsAuctionEntity> subscriptions;
  final String subscriptionStatus;
  final List<String> images;

  MyAuctionAdsEntity({
    required this.id,
    required this.name,
    required this.adminIgnore,
    required this.userId,
    required this.startPrice,
    required this.isFinished,
    required this.startDate,
    required this.isApproved,
    required this.supCategory,
    required this.mainCategory,
    required this.smallPrice,
    required this.needPrice,
    required this.adId,
    required this.isPremium,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.ad,
    required this.user,
    required this.subscriptions,
    required this.subscriptionStatus,
    required this.images,
  });
}
