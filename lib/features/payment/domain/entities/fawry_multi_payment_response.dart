import 'package:fourtyninehub/features/payment/domain/entities/fawry_save_card_token_response_entity.dart';

class MutliPaymentResponse {
  final bool status;
  final String message;
  final PaymentData data;

  MutliPaymentResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MutliPaymentResponse.fromJson(Map<String, dynamic> json) {
    return MutliPaymentResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] is String
          ? json['data']
          : PaymentData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}
