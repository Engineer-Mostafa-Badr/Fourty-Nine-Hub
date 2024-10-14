import '../../domain/entity/user_search_entity.dart';

class UserSearchModel extends UserSearchEntity {
  UserSearchModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.gender,
      required super.username,
      required super.phone,
      required super.image});

  factory UserSearchModel.fromJson(Map<String, dynamic> json) {
    return UserSearchModel(
      id: json['_id'] ??'',
      firstName: json['firstName'] ??'',
      lastName: json['lastName'] ??'',
      email: json['email'] ??'',
      gender: json['gender'] ??'',
      username: json['username'] ??'',
      phone: json['phone'] ??'',
      image: json['USER_PROFILE']['profilePictureKey']['mediaKey'] ??'',
    );
  }
}
