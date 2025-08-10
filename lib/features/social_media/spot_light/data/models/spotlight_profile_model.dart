import 'package:fourtyninehub/features/social_media/spot_light/data/models/spotlight_media_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_profile_entity.dart';


class SpotlightProfileModel extends SpotlightProfileEntity {
  const SpotlightProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.username,
    super.profilePicture,
    super.bio,
    super.birthDate,
    super.zodiacSign,
    required super.isOnline,
    required super.mutualFriendsCount,
    required super.mediaCount,
    required super.recentMedia,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SpotlightProfileModel.fromJson(Map<String, dynamic> json) {
    return SpotlightProfileModel(
      id: json['id'] ?? json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      profilePicture: json['profilePicture'],
      bio: json['bio'],
      birthDate: json['birthDate'] != null 
          ? DateTime.parse(json['birthDate']) 
          : null,
      zodiacSign: json['zodiacSign'],
      isOnline: json['isOnline'] ?? false,
      mutualFriendsCount: json['mutualFriendsCount'] ?? 0,
      mediaCount: json['mediaCount'] ?? 0,
      recentMedia: (json['recentMedia'] as List<dynamic>?)
              ?.map((e) => SpotlightMediaModel.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'profilePicture': profilePicture,
      'bio': bio,
      'birthDate': birthDate?.toIso8601String(),
      'zodiacSign': zodiacSign,
      'isOnline': isOnline,
      'mutualFriendsCount': mutualFriendsCount,
      'mediaCount': mediaCount,
      'recentMedia': recentMedia.map((e) => (e as SpotlightMediaModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}




// 


// 


// 
