class SubscriptionAdsAuctionEntity {
  final String id;
  final bool isPremium;
  final String expirePremium;
  final String expireSubscription;
  final bool isActive;

  SubscriptionAdsAuctionEntity({
    required this.id,
    required this.isPremium,
    required this.expirePremium,
    required this.expireSubscription,
    required this.isActive,
  });
}
