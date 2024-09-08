
class DeleteCardResponse {
  final bool status;
  final String message;
  final DeleteCardData data;

  DeleteCardResponse({
    required this.status,
    required this.message,
    required this.data,
  });
}

class DeleteCardData {
  final String type;
  final int statusCode;
  final String statusDescription;
  final bool basketPayment;

  DeleteCardData({
    required this.type,
    required this.statusCode,
    required this.statusDescription,
    required this.basketPayment,
  });
}
