import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/profile_picture_key_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/user_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.userId,
    required ProfilePictureKeyModel super.profilePictureKey,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'],
      userId: json['userId'],
      profilePictureKey:
          ProfilePictureKeyModel.fromJson(json['profilePictureKey']),
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required UserProfileModel super.userProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      userProfile: UserProfileModel.fromJson(json['USER_PROFILE']),
    );
  }
}
