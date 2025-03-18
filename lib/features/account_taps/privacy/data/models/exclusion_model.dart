import '../../domain/entities/exclusion_entity.dart';

import '../../domain/entities/exclusion_entity.dart';

class ExclusionModel extends ExclusionEntity {
  ExclusionModel({
    bool? status,
    ExclusionDataEntity? data,
  }) : super(status: status, data: data);

  factory ExclusionModel.fromJson(Map<String, dynamic> json) {
    return ExclusionModel(
      status: json['status'] as bool?,
      data: json['data'] != null
          ? ExclusionDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class ExclusionDataModel extends ExclusionDataEntity {
  ExclusionDataModel({
    List<UserEntity>? allowedUsers,
    List<UserEntity>? forbiddenUsers,
  }) : super(allowedUsers: allowedUsers, forbiddenUsers: forbiddenUsers);

  factory ExclusionDataModel.fromJson(Map<String, dynamic> json) {
    print("JSON data: $json");  // Log the raw JSON to debug
    return ExclusionDataModel(
      allowedUsers: (json['allowedUsers'] as List<dynamic>?)
          ?.map((userJson) => UserModel.fromJson(userJson))
          .toList(),
      forbiddenUsers: (json['forbiddenUsers'] as List<dynamic>?)
          ?.map((userJson) => UserModel.fromJson(userJson))
          .toList(),
    );
  }
}

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String username,
    required String firstName,
    required String lastName,
    required ProfilePictureEntity profilePictureKey,
  }) : super(
    id: id,
    username: username,
    firstName: firstName,
    lastName: lastName,
    profilePictureKey: profilePictureKey,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      // If profilePictureKey is not null, parse it
      profilePictureKey: json['profilePictureKey'] != null
          ? ProfilePictureModel.fromJson(json['profilePictureKey'])
          : ProfilePictureModel(id: "", mediaKey: ""),
    );
  }
}

class ProfilePictureModel extends ProfilePictureEntity {
  ProfilePictureModel({
    required String id,
    required String mediaKey,
  }) : super(
    id: id,
    mediaKey: mediaKey,
  );

  factory ProfilePictureModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureModel(
      id: json['_id'] as String, // Fixing _id field
      mediaKey: json['mediaKey'] as String,
    );
  }
}
