class PayWithTokenResponseEntity {
  final bool status;
  final String message;
  final PaymentTokenData data;

  PayWithTokenResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });
}

class PaymentTokenData {
  final String type;
  final String referenceNumber;
  final String merchantRefNumber;
  final int orderAmount;
  final int paymentAmount;
  final int fawryFees;
  final String orderStatus;
  final String paymentMethod;
  final int paymentTime;
  final String cardLastFourDigits;
  final String customerName;
  final String customerProfileId;
  final String authNumber;
  final String signature;
  final int taxes;
  final int statusCode;
  final String statusDescription;
  final bool basketPayment;

  PaymentTokenData({
    required this.type,
    required this.referenceNumber,
    required this.merchantRefNumber,
    required this.orderAmount,
    required this.paymentAmount,
    required this.fawryFees,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentTime,
    required this.cardLastFourDigits,
    required this.customerName,
    required this.customerProfileId,
    required this.authNumber,
    required this.signature,
    required this.taxes,
    required this.statusCode,
    required this.statusDescription,
    required this.basketPayment,
  });
}
