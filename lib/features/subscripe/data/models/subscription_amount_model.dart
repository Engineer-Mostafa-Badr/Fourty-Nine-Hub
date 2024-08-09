import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';

class SubscriptionAmountModel extends SubscriptionAmountEntity {
  SubscriptionAmountModel(
      {required super.currency,
      required super.amount,
      required super.id,
      required super.isActive});

  factory SubscriptionAmountModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionAmountModel(
      currency: json['currency'],
      amount: json['amount'],
      id: json['_id'],
      isActive: json['isActive'],
    );
  }
}
