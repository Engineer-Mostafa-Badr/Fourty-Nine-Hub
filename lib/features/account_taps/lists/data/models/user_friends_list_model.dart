import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

class UserFriendsListModel extends UserFriendEntity {
  UserFriendsListModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      super.image});

  factory UserFriendsListModel.fromJson(Map<String, dynamic> json) {
    return UserFriendsListModel(
      id: json['friendId']['_id'] ?? '',
      firstName: json['friendId']['firstName'] ?? '',
      image: json['friendId']['image'] ?? '',
      lastName: json['friendId']['lastName'] ?? '',
    );
  }
}
