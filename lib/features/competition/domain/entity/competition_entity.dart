class CompetitionEntity {
  final String id;
  final String CompetitionId;
  final num withdrawLimit;
  final num maxRequests;
  final String nameAr;
  final String nameEn;
  final String descriptionEn;
  final String descriptionAr;
  final num countOfRequest;
  final num amount;

  CompetitionEntity(
      {required this.id,
      required this.CompetitionId,
      required this.withdrawLimit,
      required this.maxRequests,
      required this.nameAr,
      required this.nameEn,
      required this.descriptionEn,
      required this.descriptionAr,
      required this.countOfRequest,
      required this.amount});
}
