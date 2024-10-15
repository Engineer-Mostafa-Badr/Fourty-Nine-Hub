import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';

class UserStarModel extends UserStarEntity {
  UserStarModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.twitterDocumentation,
      required super.image});

  factory UserStarModel.fromJson(Map<String, dynamic> json) {
      return UserStarModel(
          id: json['_id'] ??'',
          firstName: json['firstName'] ??'',
          lastName: json['lastName'] ??'',
          email: json['email'] ??'',
          twitterDocumentation: json['twitter_documentation'] ??false,
          image: json['image'] ??'',
      );
  }
}
