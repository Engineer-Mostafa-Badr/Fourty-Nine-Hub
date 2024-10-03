import 'user_profile.dart';

class UserId {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  UserProfile? userProfile;

  UserId({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.userProfile,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        userProfile: json['USER_PROFILE'] == null
            ? null
            : UserProfile.fromJson(
                json['USER_PROFILE'] as Map<String, dynamic>),
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'USER_PROFILE': userProfile?.toJson(),
        'id': id,
      };
}
