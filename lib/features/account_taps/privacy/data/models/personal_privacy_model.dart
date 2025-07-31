import '../../domain/entities/personal_privacy_entity.dart';

class PersonalPrivacyModel extends PersonalPrivacyEntity {
  PersonalPrivacyModel({
    super.userId,
    super.allowedUsers,
    super.email,
    super.phoneNumber,
    super.gender,
    super.country,
    super.city,
    super.job,
    super.birthDay,
    super.language,
  });

  factory PersonalPrivacyModel.fromJson(Map<String, dynamic> json) {
    return PersonalPrivacyModel(
      userId: json['userId'],
      allowedUsers: json['allowedUsers'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      country: json['country'],
      city: json['city'],
      job: json['job'],
      birthDay: json['birthDay'],
      language: json['language'],
    );
  }


}