class FawrySaveCardTokenResponseEntity {
  final bool status;
  final String message;
  final PaymentData data;

  FawrySaveCardTokenResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FawrySaveCardTokenResponseEntity.fromJson(Map<String, dynamic> json) {
    return FawrySaveCardTokenResponseEntity(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: PaymentData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PaymentData {
  final String type;
  final String? referenceNumber;
  final String? merchantRefNumber;
  final int? orderAmount;
  final int? paymentAmount;
  final int? fawryFees;
  final String? orderStatus;
  final String paymentMethod;
  final String? customerName;
  final String? customerProfileId;
  final String? signature;
  final String? walletQr;
  final int? expirationTime;
  final int? taxes;
  final int? statusCode;
  final String? statusDescription;
  final bool? basketPayment;
  final String? link;

  PaymentData({
    required this.type,
    this.referenceNumber,
    this.merchantRefNumber,
    this.orderAmount,
    this.paymentAmount,
    this.fawryFees,
    this.orderStatus,
    required this.paymentMethod,
    this.customerName,
    this.customerProfileId,
    this.signature,
    this.walletQr,
    this.expirationTime,
    this.taxes,
    this.statusCode,
    this.statusDescription,
    this.basketPayment,
    this.link,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      type: json['type'] ?? '',
      referenceNumber: json['referenceNumber'],
      merchantRefNumber: json['merchantRefNumber'],
      orderAmount: json['orderAmount'],
      paymentAmount: json['paymentAmount'],
      fawryFees: json['fawryFees'],
      orderStatus: json['orderStatus'],
      paymentMethod: json['paymentMethod'] ?? '',
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

class NextAction {
  final String type;
  final String redirectUrl;

  NextAction({
    required this.type,
    required this.redirectUrl,
  });

  factory NextAction.fromJson(Map<String, dynamic> json) {
    return NextAction(
      type: json['type'] as String,
      redirectUrl: json['redirectUrl'] as String,
    );
  }
}
