import 'package:fourtyninehub/features/payment/domain/entities/cache_out_entity/price_yellow_card_entity.dart';

class PriceYellowCardModel extends PriceYellowCardEntity {
  PriceYellowCardModel(
      {required super.currencyEn,required super.currencyAr, required super.yellowCardCharge});

  factory PriceYellowCardModel.fromJson(Map<String, dynamic> json) {
    return PriceYellowCardModel(
        currencyEn: json['currencyEn'] ?? '',
        currencyAr: json['currencyAr'] ?? '',
        yellowCardCharge: json['yellowCardCharge'] ?? 0);
  }
}
