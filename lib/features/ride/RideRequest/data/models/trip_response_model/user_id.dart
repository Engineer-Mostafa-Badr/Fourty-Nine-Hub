import 'user_profile.dart';

class UserId {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  UserProfile? userProfile;

  UserId({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.userProfile,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        gender: json['gender'] as String?,
        userProfile: json['USER_PROFILE'] == null
            ? null
            : UserProfile.fromJson(
                json['USER_PROFILE'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'gender': gender,
        'USER_PROFILE': userProfile?.toJson(),
        'id': id,
      };
}
