import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_token.dart';

class PayWithTokenModel extends PayWithTokenResponseEntity {
  PayWithTokenModel({
    required super.status,
    required super.message,
    required super.data,
  });

  factory PayWithTokenModel.fromJson(Map<String, dynamic> json) {
    return PayWithTokenModel(
      status: json['status'],
      message: json['message'],
      data: PaymentTokenDataModel.fromJson(json['data']),
    );
  }
}

class PaymentTokenDataModel extends PaymentTokenData {
  PaymentTokenDataModel({
    required super.type,
    required super.referenceNumber,
    required super.merchantRefNumber,
    required super.orderAmount,
    required super.paymentAmount,
    required super.fawryFees,
    required super.orderStatus,
    required super.paymentMethod,
    required super.paymentTime,
    required super.cardLastFourDigits,
    required super.customerName,
    required super.customerProfileId,
    required super.authNumber,
    required super.signature,
    required super.taxes,
    required super.statusCode,
    required super.statusDescription,
    required super.basketPayment,
  });

  factory PaymentTokenDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentTokenDataModel(
      type: json['type'],
      referenceNumber: json['referenceNumber'],
      merchantRefNumber: json['merchantRefNumber'],
      orderAmount: json['orderAmount'],
      paymentAmount: json['paymentAmount'],
      fawryFees: json['fawryFees'],
      orderStatus: json['orderStatus'],
      paymentMethod: json['paymentMethod'],
      paymentTime: json['paymentTime'],
      cardLastFourDigits: json['cardLastFourDigits'],
      customerName: json['customerName'],
      customerProfileId: json['customerProfileId'],
      authNumber: json['authNumber'],
      signature: json['signature'],
      taxes: json['taxes'],
      statusCode: json['statusCode'],
      statusDescription: json['statusDescription'],
      basketPayment: json['basketPayment'],
    );
  }
}
