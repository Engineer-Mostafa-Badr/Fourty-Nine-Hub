class SubTabEntity {
  final String id;
  final String userId;
  final bool auction;
  final bool carpool;
  final bool chance;
  final bool installment;
  final bool tripJoin;

  SubTabEntity(
      {required this.id,
      required this.userId,
      required this.auction,
      required this.carpool,
      required this.chance,
      required this.installment,
      required this.tripJoin});
}
