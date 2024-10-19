import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/subscription_ad_auction_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/user_auction_entity.dart';
import 'my_auction_image_entity.dart';
import 'my_auction_main_category.dart';
import 'my_auction_sub_category_entity.dart';

class MyAuctionAdsEntity {
  final String id;
  final String userId;
  final String title;
  final String desc;
  final num price;
  final DateTime createdAt;
  final String phone;
  final bool adminIgnore;
  final bool isFavourite;
  final MyAuctionSubCategoryEntity subCategory;
  final MyAuctionMainCategory? mainCategory;
  final bool isApproved;
  final bool isActive;
  final bool isPremium;
  final UserAuctionEntity user;
  final List<SubscriptionAdsAuctionEntity> subscriptions;
  final List<MyAuctionImageEntity> images;
  final String subscriptionStatus;
  final int phoneCountLength;
  final int chatCountLength;
  final int viewCountLength;
  final int loveCountLength;

  MyAuctionAdsEntity(
      {required this.id,
      required this.userId,
      required this.title,
      required this.desc,
      required this.price,
      required this.createdAt,
      required this.phone,
      required this.adminIgnore,
      required this.isFavourite,
      required this.subCategory,
        this.mainCategory,
      required this.isApproved,
      required this.isActive,
      required this.isPremium,
      required this.user,
      required this.subscriptions,
      required this.images,
      required this.subscriptionStatus,
      required this.phoneCountLength,
      required this.chatCountLength,
      required this.viewCountLength,
      required this.loveCountLength});

// final List<String> images;
}
