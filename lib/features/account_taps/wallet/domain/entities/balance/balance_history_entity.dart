class BalanceHistoryEntity {
  final String id;
  final String userId;
  final String subCategoryId;
  final num taxPrice;
  final num transactionAmount;
  final String transactionPurpose;
  final String internalPayment;
  final String currency;
  final bool isPaid;
  final String status;
  final String createdAt;

  BalanceHistoryEntity(
      {required this.id,
      required this.userId,
      required this.subCategoryId,
      required this.taxPrice,
      required this.transactionAmount,
      required this.transactionPurpose,
      required this.internalPayment,
      required this.currency,
      required this.isPaid,
      required this.status,
      required this.createdAt});
}
