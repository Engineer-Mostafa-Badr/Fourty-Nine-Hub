class FollowersEntity {
  final String id;
  final String followerId;
  final String firstName;
  final String lastname;
  final String email;
  final String image;
  final String followingId;
  final String userId;

  FollowersEntity(
      {required this.id,
      required this.followerId,
      required this.userId,
      required this.firstName,
      required this.lastname,
      required this.email,
      required this.image,
      required this.followingId});
}
