class InstaPayResponseEntity {
  final bool status;
  final String message;
  final InstaPaytData data;

  InstaPayResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });
}

class InstaPaytData {
  final String receiptURL;
  final Transaction transaction;

  InstaPaytData({
    required this.receiptURL,
    required this.transaction,
  });
}

class Transaction {
  final String userId;
  final String subCategoryId;
  final String paymentProviderId;
  final double taxPrice;
  final String receiptKey;
  final String amountId;
  final double transactionAmount;
  final String transactionPurpose;
  final String currency;
  final bool isPaid;
  final String status;
  final String id;
  final int version;

  Transaction({
    required this.userId,
    required this.subCategoryId,
    required this.paymentProviderId,
    required this.taxPrice,
    required this.receiptKey,
    required this.amountId,
    required this.transactionAmount,
    required this.transactionPurpose,
    required this.currency,
    required this.isPaid,
    required this.status,
    required this.id,
    required this.version,
  });
}

class InstaPayParams {
  final String receiptId;
  final String amountId;
  final String paymentProviderId;

  InstaPayParams({
    required this.receiptId,
    required this.amountId,
    required this.paymentProviderId,
  });
}
