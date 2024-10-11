class CompetitionsWalletEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final int maxRequests;
  final int countOfRequest;
  final bool isWinner;

  CompetitionsWalletEntity({
    required this.id,
    required this.maxRequests,
    required this.countOfRequest,
    required this.nameAr,
    required this.nameEn,
    required this.isWinner,
  });
}
