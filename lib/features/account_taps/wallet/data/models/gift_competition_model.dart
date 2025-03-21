import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_competitions_entity.dart';

class GiftCompetitionModel extends GiftCompetitionEntity {
  GiftCompetitionModel(
      {required super.withdrawLimit,
      required super.pricePerRequest,
      required super.maxRequests,
      required super.nameEn,
      required super.descriptionEn,
      required super.nameAr,
      required super.descriptionAr,
      required super.id,
      required super.countOfRequest,
      required super.amount,
      required super.descriptionGiftWalletEn,
      required super.descriptionGiftWalletAr});

  factory GiftCompetitionModel.fromJson(Map<String, dynamic> json) {
    return GiftCompetitionModel(
      id: json["competition_id"]["_id"],
      withdrawLimit: json['competition_id']["withdrawLimit"],
      pricePerRequest: json['competition_id']["pricePerRequest"],
      maxRequests: json['competition_id']["maxRequests"],
      nameEn: json['competition_id']["nameEn"],
      descriptionEn: json['competition_id']["descriptionEn"],
      descriptionAr: json['competition_id']["descriptionAr"],
      descriptionGiftWalletEn: json["competition_id"]["descriptionGiftWalletEn"],
      descriptionGiftWalletAr: json["competition_id"]["descriptionGiftWalletAr"],
      nameAr: json['competition_id']["nameAr"],
      countOfRequest: json["countOfRequest"],
      amount: json["amount"],
    );
  }
}
