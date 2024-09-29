class UserAuctionEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool twitterDocumentation;
  final UserAuctionProfile profile;

  UserAuctionEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.twitterDocumentation,
      required this.profile});

}

class UserAuctionProfile {
  final String id;
  final ProfilePictureKey profilePictureKey;

  UserAuctionProfile({
    required this.id,
    required this.profilePictureKey
  });


}


class ProfilePictureKey {
  final String id;
  final String user;
  final String subcategoryId;
  final String mimetype;
  final int size;
  final String mediaKey;
  final bool successUpload;
  final String createdAt;
  final String updatedAt;

  ProfilePictureKey({
    required this.id,
    required this.user,
    required this.subcategoryId,
    required this.mimetype,
    required this.size,
    required this.mediaKey,
    required this.successUpload,
    required this.createdAt,
    required this.updatedAt,
  });

}
