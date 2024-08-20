class SuggestUserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final num mutualFriendsCount;
  final String profilePicture;
  bool? addedSuccessfully;
  bool? followSuccessfully;
  bool? sendWelcomeSuccessfully;

  SuggestUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mutualFriendsCount,
    required this.profilePicture,
    this.addedSuccessfully = false,
    this.followSuccessfully = false,
    this.sendWelcomeSuccessfully = false,
  });
}
