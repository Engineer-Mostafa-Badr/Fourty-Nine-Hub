import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_card_entity.dart';


class FawryPayWithCardModel extends FawryPayWithCardEntity {
  FawryPayWithCardModel({
    required bool status,
    required String message,
    required FawryData data,
  }) : super(
    status: status,
    message: message,
    data: data,
  );

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
    required String type,
    required NextAction nextAction,
    required int statusCode,
    required String statusDescription,
    required bool basketPayment,
  }) : super(
    type: type,
    nextAction: nextAction,
    statusCode: statusCode,
    statusDescription: statusDescription,
    basketPayment: basketPayment,
  );

  factory FawryDataModel.fromJson(Map<String, dynamic> json) {
    return FawryDataModel(
      type: json['type'] as String,
      nextAction: NextActionModel.fromJson(json['nextAction'] as Map<String, dynamic>),
      statusCode: json['statusCode'] as int,
      statusDescription: json['statusDescription'] as String,
      basketPayment: json['basketPayment'] as bool,
    );
  }
}



class NextActionModel extends NextAction {
  NextActionModel({
    required String type,
    required String redirectUrl,
  }) : super(
    type: type,
    redirectUrl: redirectUrl,
  );

  factory NextActionModel.fromJson(Map<String, dynamic> json) {
    return NextActionModel(
      type: json['type'] as String,
      redirectUrl: json['redirectUrl'] as String,
    );
  }
}

