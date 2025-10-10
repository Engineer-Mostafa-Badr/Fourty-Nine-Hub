import '../../domain/entity/user_star_entity.dart';

class UserStarModel extends UserStarEntity {
  UserStarModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.image,
    required super.viewNumber,
    required super.averageRating,
    super.gender,
  });

  factory UserStarModel.fromJson(Map<String, dynamic> json) {
    return UserStarModel(
      id: json['_id'] ?? '',
      firstName: json['userId'] != null
          ? json['userId']['firstName']
          : json['firstName'] ?? '',
      lastName: json['userId'] != null
          ? json['userId']['lastName']
          : json['lastName'] ?? '',
      email: json['userId'] != null
          ? json['userId']['email'] ?? ''
          : json['email'] ?? '',
      image: json['userId'] != null
          ? json['userId']['USER_PROFILE']['profilePictureKey']['mediaKey']
          : json['USER_PROFILE']['profilePictureKey']['mediaKey'] ?? '',
      viewNumber: json['viewNumber  '] ?? 0,
      averageRating: json['averageRating'] ?? 0,
      gender: json['userId'] != null
          ? json['userId']['gender'] ?? 'male'
          : json['gender'] ?? 'male',
    );
  }
}
