import 'package:fourtyninehub/features/payment/data/models/card_token_data_model.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_card_token_response_entity.dart';

class FawryCardTokenResponseModel {
  final bool status;
  final String message;
  final CardTokenDataModel data;

  FawryCardTokenResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FawryCardTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return FawryCardTokenResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: CardTokenDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  FawryCardTokenResponseEntity toEntity() {
    return FawryCardTokenResponseEntity(
      status: status,
      message: message,
      data: data.toEntity(),
    );
  }
}
