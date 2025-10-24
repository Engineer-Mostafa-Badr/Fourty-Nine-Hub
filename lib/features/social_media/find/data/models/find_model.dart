
import 'package:fourtyninehub/features/social_media/find/domain/entity/find_entity.dart';

class FindModel extends FindEntity {
  const FindModel({
    String? id,
    String? firstName,
    String? lastName,
    String? birthday,
    LocationModel? location,
    int? followingCount,
    int? followersCount,
    int? friendsCount,
    bool? areFriends,
    List<String>? pictures,
    bool? hasStory,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    birthday: birthday,
    location: location,
    followingCount: followingCount,
    followersCount: followersCount,
    friendsCount: friendsCount,
    areFriends: areFriends,
    pictures: pictures,
    hasStory: hasStory,
  );

  factory FindModel.fromJson(Map<String, dynamic> json) {
    return FindModel(
      id: json['id'] ?? json['_id'], // ✅ FIXED
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthday: json['birthday'] as String?,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      followingCount: json['followingCount'] as int?,
      followersCount: json['followersCount'] as int?,
      friendsCount: json['friendsCount'] as int?,
      areFriends: json['areFriends'] as bool?,
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasStory: json['hasStory'] as bool?,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
      'location': (location as LocationModel?)?.toJson(),
      'followingCount': followingCount,
      'followersCount': followersCount,
      'friendsCount': friendsCount,
      'areFriends': areFriends,
      'pictures': pictures,
      'hasStory': hasStory,
    };
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({
    String? type,
    List<double>? coordinates,
  }) : super(type: type, coordinates: coordinates);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
