import 'profile_picture_key.dart';

class UserProfile {
  String? id;
  String? userId;
  ProfilePictureKey? profilePictureKey;

  UserProfile({this.id, this.userId, this.profilePictureKey});

  @override
  String toString() {
    return 'UserProfile(id: $id, userId: $userId, profilePictureKey: $profilePictureKey)';
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
        profilePictureKey: json['profilePictureKey'] == null
            ? null
            : ProfilePictureKey.fromJson(
                json['profilePictureKey'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'profilePictureKey': profilePictureKey?.toJson(),
      };
}
