import 'package:fourtyninehub/features/payment/domain/entities/cache_out_entity/price_yellow_card_entity.dart';

class PriceYellowCardModel extends PriceYellowCardEntity {
  PriceYellowCardModel(
      {required super.currency, required super.yellowCardCharge});

  factory PriceYellowCardModel.fromJson(Map<String, dynamic> json) {
    return PriceYellowCardModel(
        currency: json['currency'] ?? '',
        yellowCardCharge: json['yellowCardCharge'] ?? 0);
  }
}
