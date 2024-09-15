import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_token.dart';

class PayWithTokenModel extends PayWithTokenResponseEntity {
  PayWithTokenModel({
    required bool status,
    required String message,
    required PaymentTokenData data,
  }) : super(
          status: status,
          message: message,
          data: data,
        );

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
    required String type,
    required String referenceNumber,
    required String merchantRefNumber,
    required int orderAmount,
    required int paymentAmount,
    required int fawryFees,
    required String orderStatus,
    required String paymentMethod,
    required int paymentTime,
    required String cardLastFourDigits,
    required String customerName,
    required String customerProfileId,
    required String authNumber,
    required String signature,
    required int taxes,
    required int statusCode,
    required String statusDescription,
    required bool basketPayment,
  }) : super(
          type: type,
          referenceNumber: referenceNumber,
          merchantRefNumber: merchantRefNumber,
          orderAmount: orderAmount,
          paymentAmount: paymentAmount,
          fawryFees: fawryFees,
          orderStatus: orderStatus,
          paymentMethod: paymentMethod,
          paymentTime: paymentTime,
          cardLastFourDigits: cardLastFourDigits,
          customerName: customerName,
          customerProfileId: customerProfileId,
          authNumber: authNumber,
          signature: signature,
          taxes: taxes,
          statusCode: statusCode,
          statusDescription: statusDescription,
          basketPayment: basketPayment,
        );

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
