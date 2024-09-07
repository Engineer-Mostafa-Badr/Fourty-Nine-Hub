import '../../../domain/entities/wallet/wallet_subscription_entity.dart';

class WalletSubscriptionModel extends WalletSubscriptionEntity {
  WalletSubscriptionModel(
      {required super.id,
      required super.userId,
      required super.subCategoryId,
      required super.nameAr,
      required super.nameEn,
      required super.isPremium,
      required super.expirePremium,
      required super.expireSubscription,
      required super.isActive,
      required super.createdAt, required super.picture});

  factory WalletSubscriptionModel.fromJson(Map<String, dynamic> json) {
      return WalletSubscriptionModel(
          id: json['_id'] ??'',
          userId: json['userId'] ??'',
          subCategoryId: json['subCategoryId']['_id'] ??'',
          picture: json['subCategoryId']['picture'] ??'',
          nameAr: json['subCategoryId']['nameAr'] ??0,
          nameEn: json['subCategoryId']['nameEn'] ??0,
          isPremium: json['isPremium'] ??false,
          expirePremium: json['expirePremium'],
          expireSubscription: json['ExpireSubscription'],
          isActive: json['isActive'] ??false,
          createdAt: json['createdAt'] ??'',
      );
  }
}
