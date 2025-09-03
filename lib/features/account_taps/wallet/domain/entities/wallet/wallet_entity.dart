class WalletEntity {
  final num? realAmount;
  final num? holdingAmount;
  final bool isWaitingApproval;
  final String currencyEn;
  final String currencyAr;

  WalletEntity({
    required this.realAmount,
    required this.holdingAmount,
    required this.isWaitingApproval,
    required this.currencyEn,
    required this.currencyAr,
  });
}
