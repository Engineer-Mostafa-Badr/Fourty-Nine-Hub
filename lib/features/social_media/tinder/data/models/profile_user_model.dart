// import 'dart:convert';
//
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
//
// class ProfileUserModel {
//   final bool status;
//   final ProfileUserData data;
//
//   ProfileUserModel({
//     required this.status,
//     required this.data,
//   });
//
//   factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
//     return ProfileUserModel(
//       status: json['status'],
//       data: ProfileUserData.fromJson(json['data']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'data': data.toJson(),
//     };
//   }
// }
//
// class ProfileUserData {
//   final String id;
//   final UserId userId;
//   final List<Picture> pictures;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int followersCount;
//   final int followingCount;
//   final int friendsCount;
//
//   ProfileUserData({
//     required this.id,
//     required this.userId,
//     required this.pictures,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.followersCount,
//     required this.followingCount,
//     required this.friendsCount,
//   });
//
//   factory ProfileUserData.fromJson(Map<String, dynamic> json) {
//     return ProfileUserData(
//       id: json['_id'],
//       userId: UserId.fromJson(json['userId']),
//       pictures:
//           List<Picture>.from(json['pictures'].map((x) => Picture.fromJson(x))),
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       followersCount: json['followersCount'],
//       followingCount: json['followingCount'],
//       friendsCount: json['friendsCount'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId.toJson(),
//       'pictures': List<dynamic>.from(pictures.map((x) => x.toJson())),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'followersCount': followersCount,
//       'followingCount': followingCount,
//       'friendsCount': friendsCount,
//     };
//   }
// }
//
// class UserId {
//   final String id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String? birthday;
//   final String gender;
//   final Location location;
//
//   UserId({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     this.birthday,
//     required this.gender,
//     required this.location,
//   });
//
//   factory UserId.fromJson(Map<String, dynamic> json) {
//     return UserId(
//       id: json['_id'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       birthday: json['birthday'],
//       gender: json['gender'],
//       location: Location.fromJson(json['location']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'birthday': birthday,
//       'gender': gender,
//       'location': location.toJson(),
//     };
//   }
// }
//
// class Location {
//   final String type;
//   final List<double> coordinates;
//
//   Location({
//     required this.type,
//     required this.coordinates,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       type: json['type'],
//       coordinates:
//           List<double>.from(json['coordinates'].map((x) => x.toDouble())),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
//     };
//   }
// }
//
// // class ProfilePicture {
// //   final String id;
// //   final String mediaKey;
// //
// //   ProfilePicture({
// //     required this.id,
// //     required this.mediaKey,
// //   });
// //
// //   factory ProfilePicture.fromJson(Map<String, dynamic> json) {
// //     return ProfilePicture(
// //       id: json['_id'],
// //       mediaKey: json['mediaKey'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'mediaKey': mediaKey,
// //     };
// //   }
// // }

import 'dart:convert';

class ProfileUserModel {
  final bool status;
  final ProfileUserData data;

  ProfileUserModel({
    required this.status,
    required this.data,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      status: json['status'],
      data: ProfileUserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ProfileUserData {
  final bool adminIgnore;
  final String id;
  final UserId userId;
  final List<ProfilePictureModel> pictures;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int followersCount;
  final int followingCount;
  final int friendsCount;

  ProfileUserData({
    required this.adminIgnore,
    required this.id,
    required this.userId,
    required this.pictures,
    required this.createdAt,
    required this.updatedAt,
    required this.followersCount,
    required this.followingCount,
    required this.friendsCount,
  });

  factory ProfileUserData.fromJson(Map<String, dynamic> json) {
    return ProfileUserData(
      adminIgnore: json['adminIgnore'],
      id: json['_id'],
      userId: UserId.fromJson(json['userId']),
      pictures: List<ProfilePictureModel>.from(
          json['pictures'].map((x) => ProfilePictureModel.fromJson(x))),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
      friendsCount: json['friendsCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminIgnore': adminIgnore,
      '_id': id,
      'userId': userId.toJson(),
      'pictures': List<dynamic>.from(pictures.map((x) => x.toJson())),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'followersCount': followersCount,
      'followingCount': followingCount,
      'friendsCount': friendsCount,
    };
  }
}

class UserId {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? birthday;
  final String gender;
  final Location location;

  UserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthday,
    required this.gender,
    required this.location,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthday: json['birthday'],
      gender: json['gender'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'birthday': birthday,
      'gender': gender,
      'location': location.toJson(),
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

class ProfilePictureModel {
  final String id;
  final String mediaKey;

  ProfilePictureModel({
    required this.id,
    required this.mediaKey,
  });

  factory ProfilePictureModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureModel(
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
