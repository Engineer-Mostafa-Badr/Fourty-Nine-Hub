import 'package:fourtyninehub/features/payment/domain/entities/instapay_entity.dart';

class InstapayModel extends InstaPayResponseEntity {
  InstapayModel({
    required bool status,
    required String message,
    required InstaPaytDataModel data,
  }) : super(
    status: status,
    message: message,
    data: data,
  );

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
    required String receiptURL,
    required TransactionModel transaction,
  }) : super(
    receiptURL: receiptURL,
    transaction: transaction,
  );

  factory InstaPaytDataModel.fromJson(Map<String, dynamic> json) {
    return InstaPaytDataModel(
      receiptURL: json['receiptURL'] as String? ?? '',
      transaction: TransactionModel.fromJson(json['transaction'] as Map<String, dynamic>),
    );
  }
}

class TransactionModel extends Transaction {
  TransactionModel({
    required String userId,
    required String subCategoryId,
    required String paymentProviderId,
    required double taxPrice,
    required String receiptKey,
    required String amountId,
    required double transactionAmount,
    required String transactionPurpose,
    required String currency,
    required bool isPaid,
    required String status,
    required String id,
    required int version,
  }) : super(
    userId: userId,
    subCategoryId: subCategoryId,
    paymentProviderId: paymentProviderId,
    taxPrice: taxPrice,
    receiptKey: receiptKey,
    amountId: amountId,
    transactionAmount: transactionAmount,
    transactionPurpose: transactionPurpose,
    currency: currency,
    isPaid: isPaid,
    status: status,
    id: id,
    version: version,
  );

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
