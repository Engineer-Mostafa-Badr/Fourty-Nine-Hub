class WalletEntity {
  final num? realAmount;
  final bool isWaitingApproval;
  final String currencyEn;
  final String currencyAr;

  WalletEntity({
    required this.realAmount,
    required this.isWaitingApproval,
    required this.currencyEn,
    required this.currencyAr,
  });
}
