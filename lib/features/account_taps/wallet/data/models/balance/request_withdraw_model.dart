import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/request_withdraw_entity.dart';

class RequestWithdrawModel extends RequestWithdrawEntity {
  RequestWithdrawModel({required super.status, required super.data});

  factory RequestWithdrawModel.fromJson(Map<String, dynamic> json) {
    return RequestWithdrawModel(
      status: json['status'] ??false,
      data: json['data'] ??false,
    );
  }
}
