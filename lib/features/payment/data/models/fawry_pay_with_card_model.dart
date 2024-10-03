import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_card_entity.dart';

class FawryPayWithCardModel extends FawryPayWithCardEntity {
  FawryPayWithCardModel({
    required super.status,
    required super.message,
    required super.data,
  });

  factory FawryPayWithCardModel.fromJson(Map<String, dynamic> json) {
    return FawryPayWithCardModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: FawryDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class FawryDataModel extends FawryData {
  FawryDataModel({
    required super.type,
    required super.nextAction,
    required super.statusCode,
    required super.statusDescription,
    required super.basketPayment,
  });

  factory FawryDataModel.fromJson(Map<String, dynamic> json) {
    return FawryDataModel(
      type: json['type'] as String,
      nextAction:
          NextActionModel.fromJson(json['nextAction'] as Map<String, dynamic>),
      statusCode: json['statusCode'] as int,
      statusDescription: json['statusDescription'] as String,
      basketPayment: json['basketPayment'] as bool,
    );
  }
}

class NextActionModel extends NextAction {
  NextActionModel({
    required super.type,
    required super.redirectUrl,
  });

  factory NextActionModel.fromJson(Map<String, dynamic> json) {
    return NextActionModel(
      type: json['type'] as String,
      redirectUrl: json['redirectUrl'] as String,
    );
  }
}
