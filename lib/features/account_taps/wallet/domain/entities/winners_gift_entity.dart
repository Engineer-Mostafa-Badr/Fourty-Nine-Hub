class WinnersGiftEntity {
  final String userId;
  final String firstName;
  final String lastName;
  final String? profilePictureKey;
  final String competitionId;
  final String competitionNameEn;
  final String competitionNameAr;
  final num profitAmount;
  final String winAt;

  WinnersGiftEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.profilePictureKey,
    required this.competitionId,
    required this.competitionNameEn,
    required this.competitionNameAr,
    required this.profitAmount,
    required this.winAt,
  });
}
