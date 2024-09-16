import 'package:fourtyninehub/features/payment/domain/entities/fawry_multi_payment_response.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_save_card_token_response_entity.dart';

class MutliPaymentResponseModel extends MutliPaymentResponse {
  MutliPaymentResponseModel({
    required bool status,
    required String message,
    required PaymentDataModel data,
  }) : super(
          status: status,
          message: message,
          data: data,
        );

  factory MutliPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return MutliPaymentResponseModel(
      status: json['status'],
      message: json['message'],
      data: PaymentDataModel.fromJson(json['data']),
    );
  }

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
    required String type,
    String? referenceNumber,
    String? merchantRefNumber,
    int? orderAmount,
    int? paymentAmount,
    int? fawryFees,
    String? orderStatus,
    required String paymentMethod,
    String? customerName,
    String? customerProfileId,
    String? signature,
    String? walletQr,
    int? expirationTime,
    int? taxes,
    int? statusCode,
    String? statusDescription,
    bool? basketPayment,
    String? link,
  }) : super(
          type: type,
          referenceNumber: referenceNumber,
          merchantRefNumber: merchantRefNumber,
          orderAmount: orderAmount,
          paymentAmount: paymentAmount,
          fawryFees: fawryFees,
          orderStatus: orderStatus,
          paymentMethod: paymentMethod,
          customerName: customerName,
          customerProfileId: customerProfileId,
          signature: signature,
          walletQr: walletQr,
          expirationTime: expirationTime,
          taxes: taxes,
          statusCode: statusCode,
          statusDescription: statusDescription,
          basketPayment: basketPayment,
          link: link,
        );

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
