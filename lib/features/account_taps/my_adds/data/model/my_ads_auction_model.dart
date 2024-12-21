import 'package:fourtyninehub/features/account_taps/my_adds/data/model/user_auction_model.dart';

import '../../domain/entity/my_ads_auction.dart';
import 'my_auction_image_model.dart';
import 'my_auction_main_category_model.dart';
import 'my_auction_sub_category_model.dart';

class MyAuctionAdsModel extends MyAuctionAdsEntity {
  MyAuctionAdsModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.desc,
    required super.price,
    required super.createdAt,
    required super.phone,
    required super.adminIgnore,
    required super.isFavourite,
    required super.subCategory,
    super.mainCategory,
    required super.isApproved,
    required super.isActive,
    required super.isPremium,
    required super.user,
    required super.subscriptions,
    required super.images,
    required super.subscriptionStatus,
    required super.chatCountLength,
    required super.loveCountLength,
    required super.phoneCountLength,
    required super.viewCountLength,
  });

  factory MyAuctionAdsModel.fromJson(Map<String, dynamic> json) {
    return MyAuctionAdsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      price: json['price'] ?? 0,
      isActive: json['isActive'] ?? false,
      isFavourite: json['isFavorite'] ?? false,
      phone: json['phone'] ?? '',
      adminIgnore: json['adminIgnore'] ?? false,
      userId: json['user_id'] ?? '',
      isApproved: json['is_approved'] ?? false,
      subCategory: MyAuctionSubCategoryModel.fromJson(json['subCategoryId']),
      mainCategory: json['mainCategoryId']!=null?MyAuctionMainCategoryModel.fromJson(json['mainCategoryId']):null,
      isPremium: json['isPremium'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      user: UserAuctionModel.fromJson(json['user']),
      subscriptions: json['typeSubscription'] ??'',
      images: (json['images'] as List).map((e) => MyAuctionImageModel.fromJson(e)).toList(),
      subscriptionStatus: json['subscriptionStatus'] ??'',
      phoneCountLength: json['phoneCountLength'] ?? 0,
      chatCountLength: json['chatCountLength'] ?? 0,
      loveCountLength: json['loveCountLength'] ?? 0,
      viewCountLength: json['viewCountLength'] ?? 0,
      //  images: List<String>.from(json['images'] ?? []),
    );
  }
}
