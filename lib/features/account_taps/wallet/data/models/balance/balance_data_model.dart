import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';

class BalanceDataModel extends BalanceDataEntity {
  BalanceDataModel(
      {required super.balance,
      required super.tenYears,
      required super.fiveYears,
      required super.createdAt,
      required super.openBalance,
      required super.fiveYearsTransfer,
      required super.tenYearsTransfer,
      required super.fiveYearsLeft,
      required super.tenYearsLeft,
      required super.fiveYearsComplete,
      required super.tenYearsComplete, required super.currency});

  factory BalanceDataModel.fromJson(Map<String, dynamic> json) {
    return BalanceDataModel(
      balance: json['balance'],
      tenYears: json['ten_years'] ?? 0,
      fiveYears: json['five_years'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      openBalance: json['openBalance'] ?? false,
      fiveYearsComplete: json['fiveYearsComplete'] ?? false,
      tenYearsComplete: json['tenYearsComplete'] ?? false,
      fiveYearsTransfer: json['fiveYearsTransfer'] ?? false,
      tenYearsTransfer: json['tenYearsTransfer'] ?? false,
      fiveYearsLeft: json['fiveYearsLeft'] ?? 0,
      tenYearsLeft: json['tenYearsLeft'] ?? 0,
      currency: json['currency'] ?? '',
    );
  }
}
