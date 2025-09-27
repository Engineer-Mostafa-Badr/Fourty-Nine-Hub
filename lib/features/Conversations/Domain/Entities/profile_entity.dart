class ProfileEntity {
  final String id;
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime lastSeenAt;
  final bool isBirthday;
  final bool isAccountVerified;
  final String? profilePictureUrl;

  ProfileEntity({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.lastSeenAt,
    required this.isAccountVerified,
    required this.isBirthday,
    required this.profilePictureUrl,
  });
}