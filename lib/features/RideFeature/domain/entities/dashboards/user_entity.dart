import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final UserProfileEntity userProfile;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userProfile,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, userProfile];
}

class UserProfileEntity extends Equatable {
  final String id;
  final String userId;
  final ProfilePictureKeyEntity profilePictureKey;

  const UserProfileEntity({
    required this.id,
    required this.userId,
    required this.profilePictureKey,
  });

  @override
  List<Object?> get props => [id, userId, profilePictureKey];
}

class ProfilePictureKeyEntity extends Equatable {
  final String id;
  final String mediaKey;

  const ProfilePictureKeyEntity({
    required this.id,
    required this.mediaKey,
  });

  @override
  List<Object?> get props => [id, mediaKey];
}
