class FawrySaveCardTokenEntity {
  final String cardNumber;
  final String cardExpiryYear;
  final String cardExpiryMonth;
  final String cardAlias;
  final String cvv;

  FawrySaveCardTokenEntity({
    required this.cardNumber,
    required this.cardExpiryYear,
    required this.cardExpiryMonth,
    required this.cardAlias,
    required this.cvv,
  });
}
