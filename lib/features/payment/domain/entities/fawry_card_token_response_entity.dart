class FawryCardTokenResponseEntity {
  final bool status;
  final String message;
  final CardTokenDataEntity data;

  FawryCardTokenResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });
}

class CardTokenDataEntity {
  final String type;
  final int statusCode;
  final String statusDescription;
  final bool basketPayment;

  CardTokenDataEntity({
    required this.type,
    required this.statusCode,
    required this.statusDescription,
    required this.basketPayment,
  });
}
