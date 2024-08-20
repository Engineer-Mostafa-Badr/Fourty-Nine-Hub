class UserModel {
  final bool status;
  final List<UserData> data;

  UserModel({
    required this.status,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      data: List<UserData>.from(json['data'].map((x) => UserData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class UserData {
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

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.gender,
    this.location,
    this.profilePicture,
    required this.followersCount,
    required this.followingCount,
    required this.friendsCount,
    required this.pictures,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthday: json['birthday'],
      gender: json['gender'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      profilePicture: json['profilePicture'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      friendsCount: json['friendsCount'] ?? 0,
      pictures: json['pictures'] != null
          ? List<TinderUserPicture>.from(
              json['pictures'].map((x) => TinderUserPicture.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'birthday': birthday,
      'gender': gender,
      'location': location?.toJson(),
      'profilePicture': profilePicture,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'friendsCount': friendsCount,
      'pictures': List<dynamic>.from(pictures.map((x) => x.toJson())),
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates:
          List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
    };
  }
}

class TinderUserPicture {
  final String id;
  final String mediaKey;

  TinderUserPicture({
    required this.id,
    required this.mediaKey,
  });

  factory TinderUserPicture.fromJson(Map<String, dynamic> json) {
    return TinderUserPicture(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}
