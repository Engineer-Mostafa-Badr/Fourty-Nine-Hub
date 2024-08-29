class UserProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String bio;
  final String city;
  final String country;
  final String job;
  final String phone;
  final int? totalView;
  final String? profilePicture;
  final String? profileCover;
  int? friendsCount;
  final int? followersCount;
  final int? followingCount;
  bool? isFollowed;
  bool? areFriends;
  bool? isSenTRequest;
  bool? sentFriendRequest;
  bool? isDocument;
  bool? isBlock;

  String get fullName => '$firstName $lastName';
  bool isMyAccount(String anotherId) {
    return id == anotherId;
  }

  UserProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.totalView,
    required this.profilePicture,
    required this.profileCover,
    required this.friendsCount,
    required this.followersCount,
    required this.followingCount,
    this.isFollowed = false,
    this.areFriends = false,
    this.isDocument = false,
    this.isSenTRequest = false,
    this.sentFriendRequest = false,
    this.isBlock = false,
    required this.bio,
    required this.city,
    required this.country,
    required this.job,
    required this.phone,

  });
}
