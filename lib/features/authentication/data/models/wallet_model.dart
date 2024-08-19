class WalletModel {
  String? id;
  String? userId;
  int? balance;
  int? grossMoney;
  int? monthlyBalance;
  int? total;
  int? months;
  int? tenYears;
  int? fiveYears;
  int? providerCashBack;
  int? refundStorage;
  int? freeClickStorage;
  int? referralStorage;
  int? referralCashBack;
  int? shareBalance;
  int? totalPayment;
  int? totalCashBack;
  int? todayGift;
  String? lastGift;
  int? totalLikes;
  int? totalViews;
  int? totalShares;
  bool? isActive;
  double? realAmount;
  DateTime? createdAt;
  DateTime? updatedAt;

  WalletModel({
    this.id,
    this.userId,
    this.balance,
    this.grossMoney,
    this.monthlyBalance,
    this.total,
    this.months,
    this.tenYears,
    this.fiveYears,
    this.providerCashBack,
    this.refundStorage,
    this.freeClickStorage,
    this.referralStorage,
    this.referralCashBack,
    this.shareBalance,
    this.totalPayment,
    this.totalCashBack,
    this.todayGift,
    this.lastGift,
    this.totalLikes,
    this.totalViews,
    this.totalShares,
    this.isActive,
    this.realAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    id: json['_id'] as String?,
    userId: json['user_id'] as String?,
    balance: json['balance'] as int?,
    grossMoney: json['gross_money'] as int?,
    monthlyBalance: json['monthly_balance'] as int?,
    total: json['total'] as int?,
    months: json['months'] as int?,
    tenYears: json['ten_years'] as int?,
    fiveYears: json['five_years'] as int?,
    providerCashBack: json['provider_cash_back'] as int?,
    refundStorage: json['refund_storage'] as int?,
    freeClickStorage: json['free_click_storage'] as int?,
    referralStorage: json['referral_storage'] as int?,
    referralCashBack: json['referral_cash_back'] as int?,
    shareBalance: json['shareBalance'] as int?,
    totalPayment: json['total_payment'] as int?,
    totalCashBack: json['total_cash_back'] as int?,
    todayGift: json['today_gift'] as int?,
    lastGift: json['last_gift'] as String?,
    totalLikes: json['total_likes'] as int?,
    totalViews: json['total_views'] as int?,
    totalShares: json['total_shares'] as int?,
    isActive: json['isActive'] as bool?,
    realAmount: double.parse(json['realAmount'].toString()),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user_id': userId,
    'balance': balance,
    'gross_money': grossMoney,
    'monthly_balance': monthlyBalance,
    'total': total,
    'months': months,
    'ten_years': tenYears,
    'five_years': fiveYears,
    'provider_cash_back': providerCashBack,
    'refund_storage': refundStorage,
    'free_click_storage': freeClickStorage,
    'referral_storage': referralStorage,
    'referral_cash_back': referralCashBack,
    'shareBalance': shareBalance,
    'total_payment': totalPayment,
    'total_cash_back': totalCashBack,
    'today_gift': todayGift,
    'last_gift': lastGift,
    'total_likes': totalLikes,
    'total_views': totalViews,
    'total_shares': totalShares,
    'isActive': isActive,
    'realAmount': realAmount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}