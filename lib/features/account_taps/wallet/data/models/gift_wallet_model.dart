import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_wallet_entity.dart';

class GiftWalletModel extends GiftWalletEntity {
  GiftWalletModel(
      {required super.id,
      required super.userId,
        super.amount,
      required super.isActive,
      required super.createdAt,
      required super.updatedAt});
  factory GiftWalletModel.fromJson(Map<String, dynamic> json) {
    return GiftWalletModel(
      id: json['_id']??'',
      userId: json['user_id']??'',
      amount: json['amount']??0,
      isActive: json['isActive']??false,
      createdAt: json['createdAt']??'',
      updatedAt: json['updatedAt']??'',
    );
  }
}
