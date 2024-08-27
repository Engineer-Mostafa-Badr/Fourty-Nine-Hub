import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.email,
    super.profilePicture,
    super.profileCover,
    super.friendsCount,
    super.followersCount,
    super.followingCount,
    super.isRider,
    super.isDoctor,
    super.isRestaurant,
    super.isLoading,
    super.isDocument,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] ?? json['_id'],
      firstName: json['first_name'] ?? json['firstName'] ?? '',
      lastName: json['last_name'] ?? json['lastName'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      profileCover: json['coverPicture'] ?? '',
      friendsCount: json['friends_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      isRider: json['isRider'] ?? false,
      isDoctor: json['isDoctor'] ?? false,
      isRestaurant: json['isRestaurant'] ?? false,
      isLoading: json['isLoading'] ?? false,
      isDocument: json['isDocument'] ?? false,
    );
  }
}
