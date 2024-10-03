import 'profile_picture_key.dart';

class UserProfile {
  ProfilePictureKey? profilePictureKey;

  UserProfile({this.profilePictureKey});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        profilePictureKey: json['profilePictureKey'] == null
            ? null
            : ProfilePictureKey.fromJson(
                json['profilePictureKey'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'profilePictureKey': profilePictureKey?.toJson(),
      };
}
