import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';

class WheelWalletModel extends WheelWalletEntity {
  const WheelWalletModel({
    required super.id,
    required super.amount,
    required super.points,
    required super.playCount,
    required super.maxCount,
  });

  factory WheelWalletModel.fromJson(Map<String, dynamic> json) =>
      WheelWalletModel(
        id: json['walletId'] as String,
        amount: double.parse(json['amount'].toString()),
        points: double.parse(json['points'].toString()),
        playCount: json['count'],
        maxCount: json['maxCount'],
      );
}
