import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/winners_cashback_entity.dart';

class WinnersCashbackModel extends WinnersCashbackEntity {
  WinnersCashbackModel(
      {required super.userId,
      required super.firstName,
      required super.lastName,
      required super.profilePictureKey,
      required super.profitAmount,
      required super.winAt,
      });

  factory WinnersCashbackModel.fromJson(Map<String, dynamic> json) {
      return WinnersCashbackModel(
          userId: json['winnerData']['userId'],
          firstName: json['winnerData']['firstName'],
          lastName: json['winnerData']['lastName'],
          profilePictureKey: json['winnerData']['profilePictureKey'],
          profitAmount: json['profitAmount'],
          winAt: json['winAt'],
      );
  }
}
