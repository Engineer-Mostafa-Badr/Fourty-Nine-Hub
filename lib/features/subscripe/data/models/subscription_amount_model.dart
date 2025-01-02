import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';

class SubscriptionAmountModel extends SubscriptionAmountEntity {
  SubscriptionAmountModel(
      {required super.currencyAr,required super.currencyEn,
      required super.amount,
      required super.id,
      required super.isActive});

  factory SubscriptionAmountModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionAmountModel(
      currencyAr: json['currencyAr'],
      currencyEn: json['currencyEn'],
      amount: json['amount'],
      id: json['_id'],
      isActive: json['isActive'],
    );
  }
}
