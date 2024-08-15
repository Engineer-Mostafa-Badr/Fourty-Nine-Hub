import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_history_entity.dart';

class WalletHistoryModel extends WalletHistoryEntity {
  WalletHistoryModel(
      {required super.id,
      required super.amount,
      required super.description,
      required super.createdAt});
  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) {
    return WalletHistoryModel(
        id: json['id'],
        amount: json['amount'],
        description: json['description'],
        createdAt: DateTime.parse(json['created_at']));
  }
}
