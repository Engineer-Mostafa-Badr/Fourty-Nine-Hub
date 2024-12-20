import 'package:fourtyninehub/features/payment/domain/entities/cache_out_entity/payout_method_entity.dart';

class PayoutMethodModel extends PayoutMethodEntity {
  PayoutMethodModel(
      {required super.FawryCashOut,
      required super.PaymobCashOut,
      required super.YellowCardCashOut});

  factory PayoutMethodModel.fromJson(Map<String, dynamic> json) {
    return PayoutMethodModel(
      FawryCashOut: json['FawryCashOut'] ?? false,
      PaymobCashOut: json['PaymobCashOut'] ?? false,
      YellowCardCashOut: json['YellowCardCashOut'] ?? false,
    );
  }
}
