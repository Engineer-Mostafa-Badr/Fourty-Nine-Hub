class WinnersCashbackEntity {
  final String userId;
  final String firstName;
  final String lastName;
  final String? profilePictureKey;
  final num profitAmount;
  final String winAt;

  WinnersCashbackEntity({
    required this.userId,
    required this.firstName,
  required this.lastName,
  required this.profilePictureKey,
  required this.profitAmount,
  required this.winAt,
});
}