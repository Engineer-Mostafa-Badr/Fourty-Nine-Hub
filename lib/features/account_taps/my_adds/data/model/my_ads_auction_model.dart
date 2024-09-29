import 'package:fourtyninehub/features/account_taps/my_adds/data/model/subscription_ad_auction_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/user_auction_model.dart';

import '../../domain/entity/my_ads_auction.dart';
import 'ads_model.dart';

class MyAuctionAdsModel extends MyAuctionAdsEntity {
  MyAuctionAdsModel(
      {required super.id,
      required super.name,
      required super.adminIgnore,
      required super.userId,
      required super.startPrice,
      required super.isFinished,
      required super.startDate,
      required super.isApproved,
      required super.supCategory,
      required super.mainCategory,
      required super.smallPrice,
      required super.needPrice,
      required super.adId,
      required super.isPremium,
      required super.isDeleted,
      required super.createdAt,
      required super.updatedAt,
      required super.ad,
      required super.user,
      required super.subscriptions,
      required super.subscriptionStatus,
      required super.images});

factory MyAuctionAdsModel.fromJson(Map<String, dynamic> json) {
  return MyAuctionAdsModel(
    id: json['_id'] ??'',
    name: json['name']??'',
    adminIgnore: json['adminIgnore'] ??false,
    userId: json['user_id'] ??'',
    startPrice: json['start_price'].toDouble(),
    isFinished: json['is_finished'] ??false,
    startDate: json['start_date'] ??'',
    isApproved: json['is_approved'] ??false,
    supCategory: json['sup_category'] ??'',
    mainCategory: json['main_category'] ??'',
    smallPrice: json['small_price'].toDouble(),
    needPrice: json['need_price'].toDouble(),
    adId: json['ad_id'] ??'',
    isPremium: json['isPremium'] ??false,
    isDeleted: json['isDeleted']  ??false,
    createdAt: json['createdAt'] ??'',
    updatedAt: json['updatedAt'] ??'',
    ad: AdDataAuctionModel.fromJson(json['ads']),
    user: UserAuctionModel.fromJson(json['user']),
    subscriptions: (json['subscription'] as List)
        .map((e) => SubscriptionAdsAuctionModel.fromJson(e))
        .toList(),
    subscriptionStatus: json['subscriptionStatus'],
    images: List<String>.from(json['images'] ?? []),
  );
}
}
