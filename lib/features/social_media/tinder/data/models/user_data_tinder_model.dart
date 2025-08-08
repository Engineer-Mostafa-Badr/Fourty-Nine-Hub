import '../../domain/domain/user_data_tinder_entity.dart';

class UserDataTinderModel extends UserDataTinderEntity {
  UserDataTinderModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.birthday,
    required super.gender,
    required super.location,
    required super.profilePicture,
    required super.followersCount,
    required super.followingCount,
    required super.friendsCount,
    required super.areFriends,
    required super.pictures,
    required super.hasStory,
  });

  factory UserDataTinderModel.fromJson(Map<String, dynamic> json) {
    return UserDataTinderModel(
      id: json['_id']?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName']?? '',
      email: json['email']?? '',
      birthday: json['birthday']?? '',
      gender: json['gender']?? '',
      areFriends: json['areFriends'] ?? false,
      hasStory: json['hasStory'] ?? false,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      profilePicture: json['profilePicture'] is String
          ? json['profilePicture']
          : json['profilePicture']?['mediaKey'] ?? '',
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      friendsCount: json['friendsCount'] ?? 0,
      pictures: json['pictures'] != null
          ? List<TinderUserPicture>.from(
              json['pictures'].map((x) => TinderUserPictureModel.fromJson(x)),
            )
          : [],
    );
  }
}

class LocationModel extends Location {
  LocationModel({required super.type, required super.coordinates});
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type']?? '',
      coordinates:
          List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}

class TinderUserPictureModel extends TinderUserPicture {
  TinderUserPictureModel({required super.id, required super.mediaKey});

  factory TinderUserPictureModel.fromJson(Map<String, dynamic> json) {
    return TinderUserPictureModel(
      id: json['_id'] ?? '',
      mediaKey: json['mediaKey'] ?? '',
    );
  }
}
