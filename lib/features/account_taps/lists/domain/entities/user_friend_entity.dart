class UserFriendEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? image;

  UserFriendEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.image});
}
