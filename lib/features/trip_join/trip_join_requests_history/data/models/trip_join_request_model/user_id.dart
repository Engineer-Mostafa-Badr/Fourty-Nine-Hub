import 'user_profile.dart';

class UserId {
  String? id;
  String? email;
  UserProfile? userProfile;

  UserId({this.id, this.email, this.userProfile});

  @override
  String toString() {
    return 'UserId(id: $id, email: $email, userProfile: $userProfile)';
  }

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json['_id'] as String?,
        email: json['email'] as String?,
        userProfile: json['USER_PROFILE'] == null
            ? null
            : UserProfile.fromJson(
                json['USER_PROFILE'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'USER_PROFILE': userProfile?.toJson(),
      };
}
