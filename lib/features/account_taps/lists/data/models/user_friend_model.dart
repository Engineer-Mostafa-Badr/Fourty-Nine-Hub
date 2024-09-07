import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

class UserFriendModel extends UserFriendEntity {
  UserFriendModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
        super.image});

  factory UserFriendModel.fromJson(Map<String, dynamic> json) {
    return UserFriendModel(
        id: json['friendId']!=null?json['friendId']['_id']:json['receiverId']!=null?json['receiverId']['_id']:json['followingId']!=null?json['followingId']['_id']:json['_id'],
        firstName: json['friendId']!=null?json['friendId']['firstName']:json['receiverId']!=null?json['receiverId']['firstName']:json['followingId']!=null?json['followingId']['firstName']:json['firstName'],
        image: json['friendId']!=null?json['friendId']['image']:json['receiverId']!=null?json['receiverId']['image']:json['followingId']!=null?json['followingId']['image']:json['image'],
        lastName: json['friendId']!=null?json['friendId']['lastName']:json['receiverId']!=null?json['receiverId']['lastName']:json['followingId']!=null?json['followingId']['lastName']:json['lastName'],);
  }
}
