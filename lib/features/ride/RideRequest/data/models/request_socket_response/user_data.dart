import 'user_profile.dart';

class UserData {
  String? firstName;
  UserProfile? userProfile;
  dynamic id;

  UserData({this.firstName, this.userProfile, this.id});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        firstName: json['firstName'] as String?,
        userProfile: json['USER_PROFILE'] == null
            ? null
            : UserProfile.fromJson(
                json['USER_PROFILE'] as Map<String, dynamic>),
        id: json['id'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'USER_PROFILE': userProfile?.toJson(),
        'id': id,
      };
}
