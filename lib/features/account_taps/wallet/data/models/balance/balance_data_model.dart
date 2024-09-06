import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance_data_entity.dart';

class BalanceDataModel extends BalanceDataEntity {
  BalanceDataModel(
      {required super.balance,
      required super.tenYears,
      required super.fiveYears, required super.createdAt, required super.openBalance, required super.fiveYearsTransfer, required super.tenYearsTransfer});

  factory BalanceDataModel.fromJson(Map<String, dynamic> json) {
    return BalanceDataModel(
      balance: json['balance'] ??0,
      tenYears: json['ten_years'] ??0,
      fiveYears: json['five_years'] ??0,
      createdAt: json['createdAt'] ??'',
      openBalance: json['openBalance'] ??false,
      fiveYearsTransfer: json['fiveYearsTransfer'] ??false,
      tenYearsTransfer: json['tenYearsTransfer'] ??false,
    );
  }
}
