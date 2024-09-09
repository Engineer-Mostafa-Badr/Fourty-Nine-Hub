class WalletSubscriptionEntity {
  final String? id;
  final String? userId;
  final String? subCategoryId;
  final String? picture;
  final String? nameAr;
  final String? nameEn;
  final bool? isPremium;
  final String? expirePremium;
  final String? expireSubscription;
  final bool? isActive;
  final String? createdAt;

  WalletSubscriptionEntity(
      {required this.id,
      required this.userId,
      required this.subCategoryId,
      required this.picture,
      required this.nameAr,
      required this.nameEn,
      required this.isPremium,
      required this.expirePremium,
      required this.expireSubscription,
      required this.isActive,
      required this.createdAt});
}
