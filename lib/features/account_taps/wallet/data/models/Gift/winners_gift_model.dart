import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/winners_gift_entity.dart';

class WinnersGiftModel extends WinnersGiftEntity {
  WinnersGiftModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.profilePictureKey,
    required super.competitionId,
    required super.competitionNameEn,
    required super.competitionNameAr,
    required super.profitAmount,
    required super.winAt,
  });

  factory WinnersGiftModel.fromJson(Map<String, dynamic> json) {
    return WinnersGiftModel(
      userId: json['winnerDetails']['userId'],
      firstName: json['winnerDetails']['firstName'],
      lastName: json['winnerDetails']['lastName'],
      profilePictureKey: json['winnerDetails']['profilePictureKey'],
      competitionId: json['competitionDetails']['competitionId'],
      competitionNameEn: json['competitionDetails']['nameEn'],
      competitionNameAr: json['competitionDetails']['nameAr'],
      profitAmount: json['profitAmount'],
      winAt: json['winAt'],
    );
  }
}
