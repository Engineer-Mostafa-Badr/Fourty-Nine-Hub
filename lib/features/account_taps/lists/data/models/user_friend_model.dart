import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

class UserFriendModel extends UserFriendEntity {
  UserFriendModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
        super.image});

  factory UserFriendModel.fromJson(Map<String, dynamic> json) {
    return UserFriendModel(
        id: json['_id'] ?? (json['friendId']!=null?json['friendId']['_id']:json['receiverId']!=null?json['receiverId']['_id']:json['followerId']!=null?json['followerId']['_id']:json['_id']),
        firstName: json['firstName'] ?? (json['friendId']!=null?json['friendId']['firstName']:json['receiverId']!=null?json['receiverId']['firstName']:json['followerId']!=null?json['followerId']['firstName']:json['firstName']),
        image:json['image'] ?? (json['friendId']!=null?json['friendId']['image']:json['receiverId']!=null?json['receiverId']['image']:json['followerId']!=null?json['followerId']['image']:json['image']),
        lastName:json['lastName'] ?? (json['friendId']!=null?json['friendId']['lastName']:json['receiverId']!=null?json['receiverId']['lastName']:json['followerId']!=null?json['followerId']['lastName']:json['lastName']),);
  }
}
