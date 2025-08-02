import '../../domain/entities/exclusion_entity.dart';


class ExclusionModel extends ExclusionEntity {
  ExclusionModel({
    super.status,
    super.data,
  });

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
    super.allowedUsers,
    super.forbiddenUsers,
  });

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
    required super.id,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureKey,
  });

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
    required super.id,
    required super.mediaKey,
  });

  factory ProfilePictureModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureModel(
      id: json['_id'] as String, // Fixing _id field
      mediaKey: json['mediaKey'] as String,
    );
  }
}
