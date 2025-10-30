// spotlight_model.dart

import 'package:fourtyninehub/features/spotlight/domain/entities/spotlight_entity.dart';

class SpotlightModel extends SpotlightEntity {
  const SpotlightModel({
    required super.id,
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.username,
    super.birthday,
    super.profilePictureUrl,
    super.coverPictureUrl,
    required super.viewCount,
    super.aboutMe,
    super.lookingFor,
    super.distance,
    super.height,
    super.university,
    super.smoking,
    super.workout,
    super.pets = const [],
    super.education,
    super.zodiac,
    super.interests = const [],
    required super.isFriend,
  });

  factory SpotlightModel.fromJson(Map<String, dynamic> json) {
    return SpotlightModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'])
          : null,
      profilePictureUrl: json['profilePictureUrl'],
      coverPictureUrl: json['coverPictureUrl'],
      viewCount: json['viewCount'] ?? 0,
      aboutMe: json['aboutMe'],
      lookingFor: json['lookingFor'],
      distance: (json['distance'] != null)
          ? (json['distance'])
          : null,
      height:
      (json['height'] != null) ? (json['height'] as num).toDouble() : null,
      university: json['university'],
      smoking: json['smoking'],
      workout: json['workout'],
      pets: List<String>.from(json['pets'] ?? []),
      education: json['education'],
      zodiac: json['zodiac'],
      interests: List<String>.from(json['interests'] ?? []),
      isFriend: json['isFriend'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'birthday': birthday?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
      'coverPictureUrl': coverPictureUrl,
      'viewCount': viewCount,
      'aboutMe': aboutMe,
      'lookingFor': lookingFor,
      'distance': distance,
      'height': height,
      'university': university,
      'smoking': smoking,
      'workout': workout,
      'pets': pets,
      'education': education,
      'zodiac': zodiac,
      'interests': interests,
      'isFriend': isFriend,
    };
  }
}
