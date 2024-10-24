import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/my_auction_image_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/props_ads_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/subscription_ad_auction_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/user_auction_entity.dart';

class EditMyAdsEntity {
  final String id;
  final String userId;
  final String subCategoryId;
  final String mainCategoryId;
  final String title;
  final String desc;
  final num price;
  final String subscriptionStatus;
  final String phone;
  final String status;
  final UserAuctionEntity user;
  final List<PropsAdsEntity> props;
  final List<SubscriptionAdsAuctionEntity> subscriptions;
  final List<MyAuctionImageEntity> images;

  EditMyAdsEntity(
      {required this.id,
      required this.userId,
      required this.subCategoryId,
      required this.mainCategoryId,
      required this.title,
      required this.desc,
      required this.price,
      required this.subscriptionStatus,
      required this.phone,
      required this.status,
      required this.user,
      required this.props,
      required this.subscriptions,
      required this.images});
}
