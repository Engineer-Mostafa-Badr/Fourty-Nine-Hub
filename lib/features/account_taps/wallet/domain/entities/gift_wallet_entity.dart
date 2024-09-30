class GiftWalletEntity {
  final String id;
  final String userId;
  final num? amount;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  GiftWalletEntity(
      {required this.id,
      required this.userId,
      required this.amount,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
}
