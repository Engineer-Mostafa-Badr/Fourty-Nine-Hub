class ExclusionEntity {
  final bool? status;
  final ExclusionDataEntity? data;

  ExclusionEntity({
    this.status,
    this.data,
  });
}

class ExclusionDataEntity {
  final List<UserEntity>? allowedUsers;
  final List<UserEntity>? forbiddenUsers;

  ExclusionDataEntity({
    this.allowedUsers,
    this.forbiddenUsers,
  });
}

class UserEntity {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final ProfilePictureEntity profilePictureKey;

  UserEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureKey,
  });
}

class ProfilePictureEntity {
  final String id;
  final String mediaKey;

  ProfilePictureEntity({
    required this.id,
    required this.mediaKey,
  });
}
