class FawryPayWithCardEntity {
  final bool status;
  final String message;
  final FawryData data;

  FawryPayWithCardEntity({
    required this.status,
    required this.message,
    required this.data,
  });
}

class FawryData {
  final String type;
  final NextAction nextAction;
  final int statusCode;
  final String statusDescription;
  final bool basketPayment;

  FawryData({
    required this.type,
    required this.nextAction,
    required this.statusCode,
    required this.statusDescription,
    required this.basketPayment,
  });
}

class NextAction {
  final String type;
  final String redirectUrl;

  NextAction({
    required this.type,
    required this.redirectUrl,
  });
}
