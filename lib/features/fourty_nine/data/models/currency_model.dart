import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';

import '../../domain/entities/slider_item_entity.dart';

class CurrencyModel extends CurrencyEntity {
  CurrencyModel(
      {required super.id,
      required super.currencyAr,
      required super.currencyEn,
      });
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['_id']??'',
      currencyAr: json['currencyAr']??'',
      currencyEn: json['currencyEn']??'',
    );
  }
}
