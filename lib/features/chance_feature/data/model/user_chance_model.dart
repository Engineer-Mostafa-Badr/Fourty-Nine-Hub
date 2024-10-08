import '../../domain/entity/user_chance_entity.dart';

class UserChanceModel extends UserChanceEntity {
  UserChanceModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.twitterDocumentation,
      required super.image});

  factory UserChanceModel.fromJson(Map<String, dynamic> json) {
    return UserChanceModel(
      id: json['_id'] ??'',
      firstName: json['firstName'] ??'',
      lastName: json['lastName'] ??'',
      email: json['email'] ??'',
      twitterDocumentation: json['twitter_documentation'] ??'',
      image: json['image'] ??'',
    );
  }
}
