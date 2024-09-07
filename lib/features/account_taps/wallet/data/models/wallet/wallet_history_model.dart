import '../../../domain/entities/wallet/wallet_history_entity.dart';

class WalletHistoryModel extends WalletHistoryEntity {
  WalletHistoryModel(
      {required super.id,
      required super.userId,
      required super.subCategoryId,
      required super.taxPrice,
      required super.transactionAmount,
      required super.transactionPurpose,
      required super.internalPayment,
      required super.currency,
      required super.isPaid,
      required super.status,
      required super.createdAt, required super.received});

  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) {
    return WalletHistoryModel(
      id: json['_id'] ??'',
      userId: json['userId'] ??'',
      subCategoryId: json['subCategoryId'] ??'',
      taxPrice: json['taxPrice'] ??0,
      transactionAmount: json['transactionAmount'] ??0,
      transactionPurpose: json['transactionPurpose'] ??'',
      internalPayment: json['internalPayment'] ??'',
      currency: json['currency'] ??'',
      isPaid: json['isPaid'] ??false,
      received: json['received'] ??false,
      status: json['status'] ??'',
      createdAt: json['createdAt'] ??'',
    );
  }
}
