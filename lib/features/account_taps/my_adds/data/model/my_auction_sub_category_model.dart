import '../../domain/entity/my_auction_sub_category_entity.dart';

class MyAuctionSubCategoryModel extends MyAuctionSubCategoryEntity {
  MyAuctionSubCategoryModel(
      {required super.id,
      required super.isHidden,
      required super.parent,
      required super.dailyPrice,
      required super.portion,
      required super.providerPortion,
      required super.paymentFactor,
      required super.grossMoney,
      required super.picture,
      required super.index,
      required super.createdAt,
      required super.updatedAt,
      required super.overHeadFactor,
      required super.hasAuction,
      required super.nameAr,
      required super.nameEn,
      required super.nameCode,
      required super.enableChatAndCallButton,
      required super.paymentMethods,
      required super.totalOverHead});

  factory MyAuctionSubCategoryModel.fromJson(Map<String, dynamic> json) {
      return MyAuctionSubCategoryModel(
          id: json['_id']??'',
          isHidden: json['is_hidden']??false,
          parent: json['parent'] ??'',
          dailyPrice: json['daily_price'] ??0,
          portion: json['portion'] ??0,
          providerPortion: json['provider_portion'] ??0,
          paymentFactor: json['payment_factor'] ??0,
          grossMoney: json['gross_money'] ??0,
          picture: json['picture']??'',
          index: json['index'] ??0,
          createdAt: json['createdAt']??'',
          updatedAt: json['updatedAt']??'',
          overHeadFactor: json['over_head_factor'] ??0,
          hasAuction: json['has_auction']??false,
          nameAr: json['nameAr'] ??'',
          nameEn: json['nameEn']??'',
          nameCode: json['nameCode']??'',
          enableChatAndCallButton: json['enableChatAndCallButton'] ??'',
          paymentMethods: json['paymentMethods']??'',
          totalOverHead: json['total_over_head']??0,
      );
  }
}
