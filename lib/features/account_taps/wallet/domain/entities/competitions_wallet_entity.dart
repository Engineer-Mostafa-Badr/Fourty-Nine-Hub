class CompetitionsWalletEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionGiftWalletEn;
  final String descriptionGiftWalletAr;
  final int maxRequests;
  final int countOfRequest;
  final num amount;
  final bool isWinner;

  CompetitionsWalletEntity({
    required this.id,
    required this.maxRequests,
    required this.countOfRequest,
    required this.nameAr,
    required this.nameEn,
    required this.amount,
    required this.descriptionGiftWalletEn,
    required this.descriptionGiftWalletAr,
    required this.isWinner,
  });
}
