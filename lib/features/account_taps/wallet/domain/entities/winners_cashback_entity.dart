class WinnersCashbackEntity {
  final String userId;
  final String firstName;
  final String lastName;
  final String? profilePictureKey;
  final num profitAmount;
  final String winAt;
  final String currencyAr;
  final String currencyEn;

  WinnersCashbackEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.profilePictureKey,
    required this.profitAmount,
    required this.winAt,
    required this.currencyAr,
    required this.currencyEn,
  });
}
