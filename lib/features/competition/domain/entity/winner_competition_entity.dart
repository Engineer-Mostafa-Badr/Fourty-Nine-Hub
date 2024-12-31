class WinnerCompetitionEntity {
  final String id;
  final String competitionId;
  final num withdrawLimit;
  final num maxRequests;
  final String nameAr;
  final String nameEn;
  final String firstName;
  final String lastName;
  final String image;
  final num profit;
  final String createdAt;
  final int numberOfWins;

  WinnerCompetitionEntity(
      {required this.id,
      required this.competitionId,
      required this.withdrawLimit,
      required this.maxRequests,
      required this.nameAr,
      required this.nameEn,
      required this.firstName,
      required this.lastName,
      required this.image,
      required this.profit,
      required this.createdAt,
      required this.numberOfWins});
}
