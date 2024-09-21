import 'package:fourtyninehub/features/payment/domain/entities/instapay_entity.dart';

class InstapayModel extends InstaPayResponseEntity {
  InstapayModel({
    required super.status,
    required super.message,
    required InstaPaytDataModel super.data,
  });

  factory InstapayModel.fromJson(Map<String, dynamic> json) {
    return InstapayModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: InstaPaytDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class InstaPaytDataModel extends InstaPaytData {
  InstaPaytDataModel({
    required super.receiptURL,
    required TransactionModel super.transaction,
  });

  factory InstaPaytDataModel.fromJson(Map<String, dynamic> json) {
    return InstaPaytDataModel(
      receiptURL: json['receiptURL'] as String? ?? '',
      transaction: TransactionModel.fromJson(
          json['transaction'] as Map<String, dynamic>),
    );
  }
}

class TransactionModel extends Transaction {
  TransactionModel({
    required super.userId,
    required super.subCategoryId,
    required super.paymentProviderId,
    required super.taxPrice,
    required super.receiptKey,
    required super.amountId,
    required super.transactionAmount,
    required super.transactionPurpose,
    required super.currency,
    required super.isPaid,
    required super.status,
    required super.id,
    required super.version,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      userId: json['userId'] as String? ?? '',
      subCategoryId: json['subCategoryId'] as String? ?? '',
      paymentProviderId: json['paymentProviderId'] as String? ?? '',
      taxPrice: (json['taxPrice'] as num?)?.toDouble() ?? 0.0,
      receiptKey: json['receiptKey'] as String? ?? '',
      amountId: json['amountId'] as String? ?? '',
      transactionAmount: (json['transactionAmount'] as num?)?.toDouble() ?? 0.0,
      transactionPurpose: json['transactionPurpose'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      isPaid: json['isPaid'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      id: json['_id'] as String? ?? '',
      version: json['__v'] as int? ?? 0,
    );
  }
}
