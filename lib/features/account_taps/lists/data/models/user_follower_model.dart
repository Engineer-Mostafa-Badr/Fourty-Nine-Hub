import '../../domain/entities/user_friend_entity.dart';

class UserFollowerModel extends UserFriendEntity {
  UserFollowerModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      super.image});

  factory UserFollowerModel.fromJson(Map<String, dynamic> json) {
    return UserFollowerModel(
      id: json['followerId']['_id'] ?? '',
      firstName: json['followerId']['firstName'] ?? '',
      image: json['followerId']['image'] ?? '',
      lastName: json['followerId']['lastName'] ?? '',
    );
  }
}
