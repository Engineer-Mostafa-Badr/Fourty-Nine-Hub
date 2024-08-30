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
    super.wallet,
    super.followersCount,
    super.followingCount,
    super.isRider,
    super.isDoctor,
    super.isRestaurant,
    super.isLoading,
    super.isDocument,
    super.bio, super.phone, super.city, super.country, super.job, super.gender
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] ?? json['_id'],
      firstName:  json['firstName'][0].toUpperCase() + json['firstName'].substring(1).toLowerCase() ?? '',
      lastName:json['lastName'][0].toUpperCase() + json['lastName'].substring(1).toLowerCase() ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? json['profilePicture'] ?? 'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
      profileCover: json['coverPicture'] ?? '',
      friendsCount: json['friends_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      wallet: json['wallet'],
      isRider: json['isRider'] ?? false,
      isDoctor: json['isDoctor'] ?? false,
      isRestaurant: json['isRestaurant'] ?? false,
      isLoading: json['isLoading'] ?? false,
      isDocument: json['isDocument'] ?? false,
      bio: json['bio'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      job: json['job'] ?? '',
      country: json['country'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}
