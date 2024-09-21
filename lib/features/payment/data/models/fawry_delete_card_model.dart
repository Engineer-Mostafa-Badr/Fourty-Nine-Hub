import 'package:fourtyninehub/features/payment/domain/entities/fawry_delete_card_entity.dart';

class DeleteCardResponseModel extends DeleteCardResponse {
  DeleteCardResponseModel({
    required super.status,
    required super.message,
    required DeleteCardDataModel super.data,
  });

  factory DeleteCardResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteCardResponseModel(
      status: json['status'],
      message: json['message'],
      data: DeleteCardDataModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': (data as DeleteCardDataModel).toJson(),
    };
  }
}

class DeleteCardDataModel extends DeleteCardData {
  DeleteCardDataModel({
    required super.type,
    required super.statusCode,
    required super.statusDescription,
    required super.basketPayment,
  });

  factory DeleteCardDataModel.fromJson(Map<String, dynamic> json) {
    return DeleteCardDataModel(
      type: json['type'],
      statusCode: json['statusCode'],
      statusDescription: json['statusDescription'],
      basketPayment: json['basketPayment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'statusCode': statusCode,
      'statusDescription': statusDescription,
      'basketPayment': basketPayment,
    };
  }
}
