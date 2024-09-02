class CardEntity {
  final bool isDefault;
  final String id;
  final String cardToken;
  final String cardAlias;
  final String userId;
  final String brand;
  final int lastFourDigits;
  final int firstSixDigits;
  final int cvv;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardEntity({
    required this.isDefault,
    required this.id,
    required this.cardToken,
    required this.cardAlias,
    required this.userId,
    required this.brand,
    required this.lastFourDigits,
    required this.firstSixDigits,
    required this.cvv,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });
}
