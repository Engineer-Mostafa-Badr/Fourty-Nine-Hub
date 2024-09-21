class ReceiverUserWalletEntity {
  final String? id;
  final String? userId;
  final int? balance;
  final int? grossMoney;
  final int? monthlyBalance;
  final int? total;
  final int? months;
  final int? tenYears;
  final int? fiveYears;
  final double? providerCashBack;
  final int? refundStorage;
  final int? freeClickStorage;
  final int? referralStorage;
  final int? referralCashBack;
  final int? shareBalance;
  final int? totalPayment;
  final int? totalCashBack;
  final int? todayGift;
  final String? lastGift;
  final int? totalLikes;
  final int? totalViews;
  final int? totalShares;
  final bool isActive;
  final int? realAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? fiveYearsComplete;
  final bool? tenYearsComplete;

  ReceiverUserWalletEntity(
      {required this.id,
      required this.userId,
      required this.balance,
      required this.grossMoney,
      required this.monthlyBalance,
      required this.total,
      required this.months,
      required this.tenYears,
      required this.fiveYears,
      required this.providerCashBack,
      required this.refundStorage,
      required this.freeClickStorage,
      required this.referralStorage,
      required this.referralCashBack,
      required this.shareBalance,
      required this.totalPayment,
      required this.totalCashBack,
      required this.todayGift,
      required this.lastGift,
      required this.totalLikes,
      required this.totalViews,
      required this.totalShares,
      required this.isActive,
      required this.realAmount,
      required this.createdAt,
      required this.updatedAt,
      required this.fiveYearsComplete,
      required this.tenYearsComplete});
}
