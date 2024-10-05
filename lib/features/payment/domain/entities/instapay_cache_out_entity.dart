class InstapayCacheOutEntity {
  final bool status;
  final String message;
  final String id;
  final String userId;
  final String? defaultCard;
  final bool autoCharge;
  final String createdAt;
  final String updatedAt;
  final String instaPay;

  InstapayCacheOutEntity(
      {required this.status,
      required this.message,
      required this.id,
      required this.userId,
      required this.defaultCard,
      required this.autoCharge,
      required this.createdAt,
      required this.updatedAt,
      required this.instaPay});
}
