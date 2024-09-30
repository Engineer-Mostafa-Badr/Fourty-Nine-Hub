import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/subscription_ad_auction_entity.dart';

class SubscriptionAdsAuctionModel extends SubscriptionAdsAuctionEntity {
  SubscriptionAdsAuctionModel(
      {required super.id,
      required super.isPremium,
      required super.expirePremium,
      required super.expireSubscription,
      required super.isActive});

  factory SubscriptionAdsAuctionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionAdsAuctionModel(
      id: json['_id'] ??'',
      isPremium: json['isPremium'] ??false,
      expirePremium: json['expirePremium'] ??'',
      expireSubscription: json['ExpireSubscription'] ??'',
      isActive: json['isActive'] ??false,
    );
  }
}
