import '../../domain/entities/personal_privacy_entity.dart';

class PersonalPrivacyModel extends PersonalPrivacyEntity {
  PersonalPrivacyModel({
    String? userId,
    Map<String, dynamic>? allowedUsers,
    String? email,
    String? phoneNumber,
    String? gender,
    String? country,
    String? city,
    String? job,
    String? birthDay,
    String? language,
  }) : super(
    userId: userId,
    allowedUsers: allowedUsers,
    email: email,
    phoneNumber: phoneNumber,
    gender: gender,
    country: country,
    city: city,
    job: job,
    birthDay: birthDay,
    language: language,
  );

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