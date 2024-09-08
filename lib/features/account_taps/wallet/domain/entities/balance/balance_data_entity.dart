class BalanceDataEntity {
  final num? balance;
  final int? tenYears;
  final int? fiveYears;
  final String? createdAt;
  final bool? openBalance;
  final bool? fiveYearsTransfer;
  final bool? tenYearsTransfer;
  final num? fiveYearsLeft;
  final num? tenYearsLeft;

  BalanceDataEntity({required this.balance, required this.tenYears,
      required this.fiveYears,
      required this.createdAt,
      required this.openBalance,
      required this.fiveYearsTransfer,
      required this.tenYearsTransfer,
      required this.fiveYearsLeft,
      required this.tenYearsLeft,
  });
}
