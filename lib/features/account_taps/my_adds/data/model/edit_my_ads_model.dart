import 'package:fourtyninehub/features/account_taps/my_adds/data/model/my_auction_image_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/my_auction_main_category_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/props_ads_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/subscription_ad_auction_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/user_auction_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/edit_my_ads_entity.dart';

import 'my_auction_sub_category_model.dart';

class EditMyAdsModel extends EditMyAdsEntity {
  EditMyAdsModel({required super.id,
    required super.userId,
    required super.subCategoryId,
    required super.mainCategoryId,
    required super.title,
    required super.desc,
    required super.price,
    required super.subscriptionStatus,
    required super.phone,
    required super.status,
    required super.user,
    required super.props,
    required super.subscriptions,
    required super.images, required super.governmentDataId, required super.governorateNameAr, required super.governorateNameEn, required super.cityDataId, required super.cityNameAr, required super.cityNameEn});


  factory EditMyAdsModel.fromJson(Map<String, dynamic> json){
    return EditMyAdsModel(id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        subCategoryId: MyAuctionSubCategoryModel.fromJson(
            json['subCategoryId']),
        mainCategoryId: MyAuctionMainCategoryModel.fromJson(
            json['mainCategoryId']),
        title: json['title'] ?? '',
        desc: json['desc'] ?? '',
        price: json['price'] ?? 0,
        subscriptionStatus: json['subscriptionStatus'] ?? '',
        phone: json['phone'] ?? '',
        status: json['status'] ?? '',
        user: UserAuctionModel.fromJson(json['user']),
        props: (json['props'] as List)
            .map((e) => PropsAdsModel.fromJson(e))
            .toList(),
        subscriptions: (json['subscription'] as List?)?.map((e) =>
            SubscriptionAdsAuctionModel.fromJson(e)).toList() ?? [],
        images: (json['images'] as List).map((e) =>
            MyAuctionImageModel.fromJson(e)).toList(),
      governmentDataId: json['governmentData']?['_id'],
      governorateNameAr: json['governmentData']?['governorate_name_ar'],
      governorateNameEn: json['governmentData']?['governorate_name_en'],
      cityDataId: json['cityData']?['_id'],
      cityNameAr: json['cityData']?['city_name_ar'],
      cityNameEn: json['cityData']?['city_name_en'],
    );
  }
}


