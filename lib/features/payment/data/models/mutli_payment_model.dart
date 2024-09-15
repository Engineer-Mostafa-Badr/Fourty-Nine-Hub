import 'package:fourtyninehub/features/payment/domain/entities/fawry_multi_payment_entity.dart';

class MutliPaymentEntityModel extends MutliPaymentEntity {
  MutliPaymentEntityModel({
    required String amountId,
    required String providerId,
    required String paymentMethod,
  }) : super(
          amountId: amountId,
          providerId: providerId,
          paymentMethod: paymentMethod,
        );

  factory MutliPaymentEntityModel.fromJson(Map<String, dynamic> json) {
    return MutliPaymentEntityModel(
      amountId: json['amountId'],
      providerId: json['providerId'],
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amountId': amountId,
      'providerId': providerId,
      'paymentMethod': paymentMethod,
    };
  }
}
