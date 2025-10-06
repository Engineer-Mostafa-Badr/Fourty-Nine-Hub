class FindEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? birthday;
  final LocationEntity? location;
  final int? followingCount;
  final int? followersCount;
  final int? friendsCount;
  final bool? areFriends;
  final List<String>? pictures;
  final bool? hasStory;

  const FindEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.birthday,
    this.location,
    this.followingCount,
    this.followersCount,
    this.friendsCount,
    this.areFriends,
    this.pictures,
    this.hasStory,
  });
}

class LocationEntity {
  final String? type;
  final List<double>? coordinates;

  const LocationEntity({this.type, this.coordinates});
}
