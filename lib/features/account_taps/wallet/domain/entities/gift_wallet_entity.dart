class GiftWalletEntity {
  final String id;
  final String userId;
  final num? amount;
  final bool isActive;
  final bool tenYearsComplete;
  final bool fiveYearsComplete;
  final num? tenYears;
  final num? fiveYears;
  final String createdAt;
  final String updatedAt;
  final String currencyEn;
  final String currencyAr;
  final bool? fiveYearsTransfer;
  final bool? tenYearsTransfer;
  final num? fiveYearsLeft;
  final num? tenYearsLeft;

  GiftWalletEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.isActive,
    required this.fiveYears,
    required this.tenYearsComplete,
    required this.tenYears,
    required this.fiveYearsComplete,
    required this.createdAt,
    required this.updatedAt,
    required this.currencyEn,
    required this.currencyAr,
    required this.fiveYearsTransfer,
    required this.tenYearsTransfer,
    required this.fiveYearsLeft,
    required this.tenYearsLeft,
  });
}
