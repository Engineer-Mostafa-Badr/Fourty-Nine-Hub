import 'package:fourtyninehub/features/payment/domain/entities/fawry_multi_payment_response.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_save_card_token_response_entity.dart';

class MutliPaymentResponseModel extends MutliPaymentResponse {
  MutliPaymentResponseModel({
    required super.status,
    required super.message,
    required PaymentDataModel super.data,
  });

  factory MutliPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return MutliPaymentResponseModel(
      status: json['status'],
      message: json['message'],
      data: PaymentDataModel.fromJson(json['data']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': (data as PaymentDataModel).toJson(),
    };
  }
}

class PaymentDataModel extends PaymentData {
  PaymentDataModel({
    required super.type,
    super.referenceNumber,
    super.merchantRefNumber,
    super.orderAmount,
    super.paymentAmount,
    super.fawryFees,
    super.orderStatus,
    required super.paymentMethod,
    super.customerName,
    super.customerProfileId,
    super.signature,
    super.walletQr,
    super.expirationTime,
    super.taxes,
    super.statusCode,
    super.statusDescription,
    super.basketPayment,
    super.link,
  });

  factory PaymentDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentDataModel(
      type: json['type'],
      referenceNumber: json['referenceNumber'],
      merchantRefNumber: json['merchantRefNumber'],
      orderAmount: json['orderAmount'],
      paymentAmount: json['paymentAmount'],
      fawryFees: json['fawryFees'],
      orderStatus: json['orderStatus'],
      paymentMethod: json['paymentMethod'],
      customerName: json['customerName'],
      customerProfileId: json['customerProfileId'],
      signature: json['signature'],
      walletQr: json['walletQr'],
      expirationTime: json['expirationTime'],
      taxes: json['taxes'],
      statusCode: json['statusCode'],
      statusDescription: json['statusDescription'],
      basketPayment: json['basketPayment'],
      link: json['link'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'referenceNumber': referenceNumber,
      'merchantRefNumber': merchantRefNumber,
      'orderAmount': orderAmount,
      'paymentAmount': paymentAmount,
      'fawryFees': fawryFees,
      'orderStatus': orderStatus,
      'paymentMethod': paymentMethod,
      'customerName': customerName,
      'customerProfileId': customerProfileId,
      'signature': signature,
      'walletQr': walletQr,
      'expirationTime': expirationTime,
      'taxes': taxes,
      'statusCode': statusCode,
      'statusDescription': statusDescription,
      'basketPayment': basketPayment,
      'link': link,
    };
  }
}
