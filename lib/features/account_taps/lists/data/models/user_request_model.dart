import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

class UserRequestModel extends UserFriendEntity {
  UserRequestModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      super.image});

  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      id: json['senderId']['_id'] ??'',
      firstName: json['senderId']['firstName'] ??'',
      image: json['senderId']['image'] ??'',
      lastName: json['senderId']['lastName'] ??'',
    );
  }
}


