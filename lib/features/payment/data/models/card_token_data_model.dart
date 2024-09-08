import 'package:fourtyninehub/features/payment/domain/entities/fawry_card_token_response_entity.dart';

class CardTokenDataModel {
  final String type;
  final int statusCode;
  final String statusDescription;
  final bool basketPayment;

  CardTokenDataModel({
    required this.type,
    required this.statusCode,
    required this.statusDescription,
    required this.basketPayment,
  });

  factory CardTokenDataModel.fromJson(Map<String, dynamic> json) {
    return CardTokenDataModel(
      type: json['type'] as String,
      statusCode: json['statusCode'] as int,
      statusDescription: json['statusDescription'] as String,
      basketPayment: json['basketPayment'] as bool,
    );
  }

  CardTokenDataEntity toEntity() {
    return CardTokenDataEntity(
      type: type,
      statusCode: statusCode,
      statusDescription: statusDescription,
      basketPayment: basketPayment,
    );
  }
}
