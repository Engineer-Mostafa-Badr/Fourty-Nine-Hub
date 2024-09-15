import 'package:fourtyninehub/features/payment/domain/entities/fawry_delete_card_entity.dart';

class DeleteCardResponseModel extends DeleteCardResponse {
  DeleteCardResponseModel({
    required bool status,
    required String message,
    required DeleteCardDataModel data,
  }) : super(
          status: status,
          message: message,
          data: data,
        );

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
    required String type,
    required int statusCode,
    required String statusDescription,
    required bool basketPayment,
  }) : super(
          type: type,
          statusCode: statusCode,
          statusDescription: statusDescription,
          basketPayment: basketPayment,
        );

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
