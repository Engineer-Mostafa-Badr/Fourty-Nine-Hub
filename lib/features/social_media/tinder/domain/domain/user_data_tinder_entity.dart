class UserDataTinderEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? birthday;
  final String? gender;
  final Location? location;
  final String? profilePicture;
  final int followersCount;
  final int followingCount;
  final int friendsCount;
  final List<TinderUserPicture> pictures;

  UserDataTinderEntity({
    required this.id,
    required   this.firstName,
    required  this.lastName,
    required  this.email,
    required this.birthday,
    required this.gender,
    required this.location,
    required this.profilePicture,
    required this.followersCount,
    required this.followingCount,
    required this.friendsCount,
    required this.pictures,
  });
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });
}

class TinderUserPicture {
  final String id;
  final String mediaKey;

  TinderUserPicture({
    required this.id,
    required this.mediaKey,
  });

}
