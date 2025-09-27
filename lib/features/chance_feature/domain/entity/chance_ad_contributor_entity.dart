class ChanceAdContributorEntity {
  final String id;
  final dynamic adId;
  final dynamic userId;
  final double amount;
  final bool isWinner;
  final String createdAt;
  final String updatedAt;

  ChanceAdContributorEntity({
    required this.id,
    required this.adId,
    required this.userId,
    required this.amount,
    required this.isWinner,
    required this.createdAt,
    required this.updatedAt,
  });
}